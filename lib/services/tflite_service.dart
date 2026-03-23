import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;

import '../core/config/app_config.dart';
import '../features/inference/domain/models/inference_result.dart';
import '../features/inference/domain/models/verification_result.dart';
import 'image_quality_service.dart';

// Platform check helpers
bool get _isAndroid => Platform.isAndroid;
bool get _isWindows => Platform.isWindows;
final tfliteServiceProvider = Provider<TFLiteService>((ref) {
  final service = TFLiteService();
  ref.onDispose(service.dispose);
  return service;
});

class TFLiteService {
  tflite.Interpreter? _interpreter;
  List<String> _labels = const [];
  bool _useAndroidMock = false;
  final ImageQualityService _qualityService = ImageQualityService();
  
  // ImageNet normalization for EfficientNet (RGB order)
  static const List<double> _imagenetMean = [0.485, 0.456, 0.406];
  static const List<double> _imagenetStd = [0.229, 0.224, 0.225];

  Future<void> _loadLabels() async {
    try {
      final raw = await rootBundle.loadString('assets/models/labels.txt');
      final lines = raw.split('\n');

      final List<_IndexedLabel> parsed = [];
      for (var line in lines) {
        var s = line.trim();
        if (s.isEmpty) continue;
        if (s.startsWith('#')) continue; // allow comments

        // Handle optional leading index formats like: "0 label" or "0: label" or "0,label"
        final RegExpMatch? m = RegExp(r'^(\d+)\s*[:,-]\s*(.+)\r?$').firstMatch(s) ??
          RegExp(r'^(\d+)\s+(.+)\r?$').firstMatch(s);

        int? idx;
        String labelRaw;
        if (m != null) {
          idx = int.tryParse(m.group(1)!);
          labelRaw = m.group(2) ?? '';
        } else {
          labelRaw = s;
        }

        final normalized = _normalizeLabel(labelRaw);
        if (normalized.isEmpty) continue;
        parsed.add(_IndexedLabel(index: idx, label: normalized));
      }

      // If any index present, try to materialize by explicit indices
      if (parsed.any((e) => e.index != null)) {
        final maxIdx = parsed.fold<int>(-1, (acc, e) => e.index != null && e.index! > acc ? e.index! : acc);
        final List<String?> tmp = List<String?>.filled(maxIdx + 1, null);
        for (final e in parsed) {
          if (e.index != null && e.index! >= 0 && e.index! < tmp.length) {
            tmp[e.index!] = e.label;
          } else if (e.index == null) {
            // Append non-indexed labels at the end
            tmp.add(e.label);
          }
        }
        _labels = tmp.whereType<String>().toList();
      } else {
        _labels = parsed.map((e) => e.label).toList();
      }
    } catch (_) {
      // Nếu không có file labels.txt, fallback cứng
      _labels = const ['Healthy', 'Class 1', 'Class 2', 'Class 3'];
    }
  }

  Future<void> loadModel() async {
    if (_interpreter != null || _useAndroidMock) return;
    
    // Windows: mock inference (no TFLite support)
    if (_isWindows) {
      await _loadLabels();
      return;
    }
    
    // Android: try to load native model with fallback
    if (_isAndroid) {
      try {
        _interpreter = await tflite.Interpreter.fromAsset(AppConfig.modelAssetPath);
        await _loadLabels();
        _logModelInfo();
      } catch (e) {
        print('⚠️ TFLite load failed on Android: $e');
        print('💡 Using mock inference fallback');
        _useAndroidMock = true;
        await _loadLabels();
      }
      return;
    }
    
    // Other platforms
    try {
      _interpreter = await tflite.Interpreter.fromAsset(AppConfig.modelAssetPath);
      await _loadLabels();
      _logModelInfo();
    } catch (e) {
      print('⚠️ TFLite load failed: $e, using mock');
      _useAndroidMock = true;
      await _loadLabels();
    }
  }

  Future<int> getLabelCount() async {
    await loadModel();
    return _labels.length;
  }

  List<String> getLabels() {
    return _labels;
  }

  Future<List<InferenceResult>> run(File imageFile) async {
    print('🖼️  [TFLiteService] Bắt đầu xử lý ảnh');
    print('   📁 Đường dẫn: ${imageFile.path}');
    
    await loadModel();
    
    if (_useAndroidMock || _interpreter == null) {
      print('⚠️  [TFLiteService] Sử dụng mock inference (model không load được)');
      return _runMockInference();
    }

    try {
      // ✅ BƯỚC 1: Decode ảnh
      print('📸 [TFLiteService] Decode ảnh...');
      final bytes = await imageFile.readAsBytes();
      var decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception('Failed to decode image');

      print('   ✅ Ảnh decode thành công: ${decoded.width}x${decoded.height}');

      // ✅ BƯỚC 2: Fix EXIF orientation
      decoded = img.bakeOrientation(decoded);
      print('   ✅ EXIF orientation fixed');

      // ✅ BƯỚC 3: Lấy input tensor info
      final inputTensor = _interpreter!.getInputTensor(0);
      final inputShape = inputTensor.shape;
      final inputTypeStr = inputTensor.type.toString().toLowerCase();
      final isFloatModel = inputTypeStr.contains('float32');
      
      print('📊 [TFLiteService] Model info:');
      print('   Input shape: $inputShape, type: $inputTypeStr');
      final modeNames = ['ImageNet RGB', 'Simple [0,1] RGB', 'ImageNet BGR', '[-1,1] RGB', 'No preprocessing (0..255)'];
      print('   Preprocessing: ${modeNames[AppConfig.preprocessingMode]}');

      // Determine layout
      final isNHWC = inputShape.length == 4 && inputShape[0] == 1 && inputShape[3] == 3;
      final isNCHW = inputShape.length == 4 && inputShape[0] == 1 && inputShape[1] == 3;

      final height = isNHWC
          ? inputShape[1]
          : isNCHW
              ? inputShape[2]
              : AppConfig.inputSize;
      final width = isNHWC
          ? inputShape[2]
          : isNCHW
              ? inputShape[3]
              : AppConfig.inputSize;

      print('   Resize to: ${width}x$height');

      // ✅ BƯỚC 4: Resize ảnh
      final resized = img.copyResize(decoded, width: width, height: height);

      // Extract RGB pixels safely
      print('   🎨 Extracting RGB pixels...');
      final rgbPixels = List<List<List<int>>>.generate(
        height,
        (y) => List<List<int>>.generate(
          width,
          (x) {
            try {
              final p = resized.getPixelSafe(x, y);
              final r = (p.r).toInt().clamp(0, 255);
              final g = (p.g).toInt().clamp(0, 255);
              final b = (p.b).toInt().clamp(0, 255);
              return [r, g, b];
            } catch (_) {
              return [0, 0, 0];
            }
          },
        ),
      );
      print('   ✅ RGB pixels extracted successfully');

      // Build input tensor in the expected layout
      const mode = AppConfig.preprocessingMode;
      dynamic input;
      if (isNHWC) {
        // [1, H, W, C]
        input = List.generate(
          1,
          (_) => List.generate(
            height,
            (y) => List.generate(
              width,
              (x) {
                final r = rgbPixels[y][x][0];
                final g = rgbPixels[y][x][1];
                final b = rgbPixels[y][x][2];
                if (isFloatModel) {
                  return _preprocessPixel(r, g, b, mode);
                } else {
                  return [r, g, b];
                }
              },
            ),
          ),
        );
      } else if (isNCHW) {
        // [1, C, H, W]
        const mode = AppConfig.preprocessingMode;
        input = List.generate(
          1,
          (_) => List.generate(
            3,
            (c) => List.generate(
              height,
              (y) => List.generate(
                width,
                (x) {
                  final r = rgbPixels[y][x][0];
                  final g = rgbPixels[y][x][1];
                  final b = rgbPixels[y][x][2];
                  if (isFloatModel) {
                    final normalized = _preprocessPixel(r, g, b, mode);
                    return normalized[c];
                  } else {
                    return rgbPixels[y][x][c];
                  }
                },
              ),
            ),
          ),
        );
      } else {
        // Unknown layout -> fallback
        throw Exception('Unsupported input layout: $inputShape');
      }

      // Prepare output tensor according to shape
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      dynamic output;
      int numClasses;
      if (outputShape.length == 2) {
        numClasses = outputShape[1];
        output = List<List<double>>.generate(1, (_) => List<double>.filled(numClasses, 0.0));
      } else if (outputShape.length == 1) {
        numClasses = outputShape[0];
        output = List<double>.filled(numClasses, 0.0);
      } else {
        // Generic fallback: treat last dim as classes
        numClasses = outputShape.last;
        output = List<List<double>>.generate(1, (_) => List<double>.filled(numClasses, 0.0));
      }

      // Run inference
      print('🚀 [TFLiteService] Chạy inference...');
      _interpreter!.run(input, output);
      print('   ✅ Inference hoàn tất');

        // Read raw output into 1D list
        final List<double> rawOut = output is List<List<double>>
          ? output[0]
          : (output as List<double>);
        print('🔍 Raw output (first 5): ${rawOut.take(math.min(5, rawOut.length)).toList()}');
        final probs = AppConfig.outputIsSoftmax ? rawOut : _softmax(rawOut);
        print('   📊 Số lượng classes: ${probs.length}');

      final indexed = List.generate(
        probs.length,
        (i) => (index: i, prob: probs[i]),
      )..sort((a, b) => b.prob.compareTo(a.prob));

      print('🔍 Top predictions:');
      for (var i = 0; i < 3 && i < indexed.length; i++) {
        final e = indexed[i];
        final label = e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
        print('   [$i] idx=${e.index}, label="$label", conf=${(e.prob * 100).toStringAsFixed(1)}%');
      }

      // Enforce top-K and threshold
      const k = AppConfig.topK <= 0 ? 1 : AppConfig.topK;
      const threshold = AppConfig.confidenceThreshold;

      // Always compute the top sorted list for logging/debug
      final topKAll = indexed.take(math.min(3, indexed.length)).map((e) {
        final label = e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
        return InferenceResult(label: label, confidence: e.prob);
      }).toList();
      if (topKAll.isNotEmpty) {
        final top1 = topKAll.first;
        if (top1.confidence >= threshold) {
          return topKAll.take(k).toList();
        } else {
          // Below threshold -> no confident prediction
          return [];
        }
      }
      return [];
    } catch (e, st) {
      print('❌ Inference failed: $e\n$st');
      print('💡 Falling back to mock');
      _useAndroidMock = true;
      return _runMockInference();
    }
  }

  /// Chạy inference với đầy đủ verification checks
  /// 
  /// Các bước kiểm tra:
  /// 1. Kiểm tra chất lượng ảnh (blur detection)
  /// 2. Chạy inference
  /// 3. Kiểm tra confidence threshold (>= 65%)
  /// 4. Kiểm tra out-of-scope detection (entropy-based)
  Future<VerificationResult> runWithVerification(File imageFile) async {
    print('🔒 [TFLiteService] Bắt đầu inference với verification');
    
    // ✅ BƯỚC 1: Kiểm tra chất lượng ảnh
    print('🔍 [Verification] Kiểm tra chất lượng ảnh...');
    final qualityResult = await _qualityService.checkImageQuality(imageFile);
    
    if (!qualityResult.isGoodQuality) {
      print('❌ [Verification] Ảnh không đạt chất lượng: ${qualityResult.reason}');
      return VerificationResult.failed(
        error: VerificationError.poorQuality,
        message: qualityResult.reason,
        imageQualityScore: qualityResult.blurScore,
      );
    }
    
    print('✅ [Verification] Chất lượng ảnh OK (score: ${qualityResult.blurScore.toStringAsFixed(1)})');
    
    // ✅ BƯỚC 2: Chạy inference
    print('🧠 [Verification] Chạy inference...');
    final predictions = await run(imageFile);
    
    if (predictions.isEmpty) {
      print('❌ [Verification] Không có kết quả dự đoán');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message: 'Không thể phân tích ảnh',
        imageQualityScore: qualityResult.blurScore,
      );
    }
    
    final topResult = predictions.first;
    print('🏆 [Verification] Top prediction: ${topResult.label} (${(topResult.confidence * 100).toStringAsFixed(1)}%)');
    
    // ✅ BƯỚC 3: Kiểm tra confidence threshold
    const confidenceThreshold = AppConfig.lowConfidenceRetakeThreshold; // 65%
    
    if (topResult.confidence < confidenceThreshold) {
      print('⚠️  [Verification] Confidence thấp: ${(topResult.confidence * 100).toStringAsFixed(1)}% < ${(confidenceThreshold * 100).toInt()}%');
      return VerificationResult.failed(
        error: VerificationError.lowConfidence,
        message: 'Độ tin cậy: ${(topResult.confidence * 100).toStringAsFixed(1)}%',
        imageQualityScore: qualityResult.blurScore,
      );
    }
    
    // ✅ BƯỚC 4: Kiểm tra out-of-scope (OOD detection)
    // Sử dụng entropy và max probability để phát hiện ảnh ngoài phạm vi
    final isOutOfScope = _detectOutOfScope(predictions);
    
    if (isOutOfScope) {
      print('❌ [Verification] Ảnh ngoài phạm vi hỗ trợ');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message: 'Không thuộc danh mục cây được hỗ trợ',
        imageQualityScore: qualityResult.blurScore,
      );
    }
    
    // ✅ Tất cả checks đều pass
    print('✅ [Verification] Tất cả checks đều pass!');
    return VerificationResult.passed(
      predictions: predictions,
      imageQualityScore: qualityResult.blurScore,
    );
  }

  /// Phát hiện ảnh ngoài phạm vi sử dụng entropy-based OOD detection
  /// 
  /// Logic:
  /// - Nếu entropy cao + max prob thấp → likely out-of-scope
  /// - Nếu prediction phân bố đều → không thuộc class nào rõ ràng
  bool _detectOutOfScope(List<InferenceResult> predictions) {
    if (predictions.isEmpty) return true;
    
    final topResult = predictions.first;
    
    // Threshold 1: Max probability quá thấp
    // Nếu prediction tốt nhất < 40% → có thể OOD
    const maxProbThresholdLow = 0.40;
    if (topResult.confidence < maxProbThresholdLow) {
      print('   🔍 OOD: Max prob quá thấp (${(topResult.confidence * 100).toStringAsFixed(1)}%)');
      return true;
    }
    
    // Threshold 2: Entropy cao (phân bố đều giữa các classes)
    // Entropy = -Σ(p * log(p))
    double entropy = 0;
    for (final pred in predictions) {
      if (pred.confidence > 0) {
        entropy -= pred.confidence * math.log(pred.confidence) / math.ln2;
      }
    }
    
    // Normalize entropy về 0-1 (max entropy = log2(n))
    final maxEntropy = math.log(predictions.length) / math.ln2;
    final normalizedEntropy = entropy / maxEntropy;
    
    print('   🔍 OOD check: entropy=${normalizedEntropy.toStringAsFixed(3)}, maxProb=${(topResult.confidence * 100).toStringAsFixed(1)}%');
    
    // Nếu entropy > 0.8 (phân bố gần như đều) → likely OOD
    const entropyThreshold = 0.80;
    if (normalizedEntropy > entropyThreshold) {
      print('   🔍 OOD: Entropy cao (${normalizedEntropy.toStringAsFixed(3)})');
      return true;
    }
    
    // Threshold 3: Gap giữa top-1 và top-2 quá nhỏ
    if (predictions.length >= 2) {
      final gap = topResult.confidence - predictions[1].confidence;
      const minGap = 0.10; // Cần chênh lệch ít nhất 10%
      
      if (gap < minGap) {
        print('   🔍 OOD: Gap giữa top-1 và top-2 quá nhỏ (${(gap * 100).toStringAsFixed(1)}%)');
        return true;
      }
    }
    
    return false;
  }

  List<InferenceResult> _runMockInference() {
    final n = _labels.isNotEmpty ? _labels.length : 4;
    final rnd = math.Random(42);
    final raw = List<double>.generate(n, (_) => rnd.nextDouble());
    final sum = raw.fold(0.0, (a, b) => a + b);
    final probs = sum > 0 ? raw.map((p) => p / sum).toList() : raw;

    final indexed = List.generate(
      probs.length,
      (i) => (index: i, prob: probs[i]),
    )..sort((a, b) => b.prob.compareTo(a.prob));

    return indexed.take(3).map((e) {
      final label = e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
      return InferenceResult(label: label, confidence: e.prob);
    }).toList();
  }

  List<double> _softmax(List<double> logits) {
    if (logits.isEmpty) return const [];
    final maxLogit = logits.reduce(math.max);
    final exps = logits.map((x) => math.exp(x - maxLogit)).toList();
    final sumExp = exps.fold(0.0, (a, b) => a + b);
    return exps.map((e) => e / (sumExp == 0 ? 1.0 : sumExp)).toList();
  }

  /// Apply preprocessing normalization based on mode
  /// mode 0: ImageNet (mean/std) RGB
  /// mode 1: Simple [0,1] RGB
  /// mode 2: ImageNet BGR (swap R-B)
  /// mode 3: [-1,1] RGB
  /// mode 4: No preprocessing (0..255 floats)
  List<double> _preprocessPixel(int r, int g, int b, int mode) {
    switch (mode) {
      case 1: // [0,1] RGB
        return [r / 255.0, g / 255.0, b / 255.0];
      
      case 2: // ImageNet BGR (swap R-B)
        return [
          (b / 255.0 - _imagenetMean[0]) / _imagenetStd[0], // B->R
          (g / 255.0 - _imagenetMean[1]) / _imagenetStd[1],
          (r / 255.0 - _imagenetMean[2]) / _imagenetStd[2], // R->B
        ];
      
      case 3: // [-1,1] RGB
        return [
          (r / 255.0 - 0.5) * 2.0,
          (g / 255.0 - 0.5) * 2.0,
          (b / 255.0 - 0.5) * 2.0,
        ];
      
      case 4: // No preprocessing, feed 0..255 floats (preprocess is embedded in model)
        return [
          r.toDouble(),
          g.toDouble(),
          b.toDouble(),
        ];
      
      case 0: // ImageNet RGB (default)
      default:
        return [
          (r / 255.0 - _imagenetMean[0]) / _imagenetStd[0],
          (g / 255.0 - _imagenetMean[1]) / _imagenetStd[1],
          (b / 255.0 - _imagenetMean[2]) / _imagenetStd[2],
        ];
    }
  }

  void _logModelInfo() {
    if (_interpreter == null) return;
    try {
      final inputT = _interpreter!.getInputTensor(0);
      final outputT = _interpreter!.getOutputTensor(0);
      print('═══ MODEL INFO ═══');
      print('📥 Input: shape=${inputT.shape}, type=${inputT.type}');
      print('📤 Output: shape=${outputT.shape}, type=${outputT.type}');
      print('🏷️  Labels: ${_labels.length} classes');
      if (_labels.length <= 12) {
        for (var i = 0; i < _labels.length; i++) {
          print('   [$i] ${_labels[i]}');
        }
      }
      print('══════════════════');
    } catch (e) {
      print('⚠️  Could not log model info: $e');
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

class _IndexedLabel {
  final int? index;
  final String label;
  const _IndexedLabel({required this.index, required this.label});
}

String _normalizeLabel(String raw) {
  var s = raw.trim();
  // Remove BOM if present
  if (s.isNotEmpty && s.codeUnitAt(0) == 0xFEFF) {
    s = s.substring(1);
  }
  // Keep the PlantName___DiseaseName format intact
  // Just remove trailing/leading whitespace and collapse multiple spaces (but not ___)
  s = s.replaceAll(RegExp(r' +'), ' ').trim();
  return s;
}

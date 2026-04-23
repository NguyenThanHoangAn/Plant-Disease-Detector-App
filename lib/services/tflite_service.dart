import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;

import '../core/config/app_config.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/inference_result.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/verification_result.dart';
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
      final raw = await rootBundle.loadString(AppConfig.LABELS_ASSET_PATH);
      final lines = raw.split('\n');

      final List<_IndexedLabel> parsed = [];
      for (var line in lines) {
        var s = line.trim();
        if (s.isEmpty) continue;
        if (s.startsWith('#')) continue; // allow comments

        // Handle optional leading index formats like: "0 label" or "0: label" or "0,label"
        final RegExpMatch? m =
            RegExp(r'^(\d+)\s*[:,-]\s*(.+)\r?$').firstMatch(s) ??
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
        final maxIdx = parsed.fold<int>(
            -1, (acc, e) => e.index != null && e.index! > acc ? e.index! : acc);
        final List<String?> tmp = List<String?>.filled(maxIdx + 1, null);
        var appendCursor = 0;
        for (final e in parsed) {
          if (e.index != null && e.index! >= 0 && e.index! < tmp.length) {
            tmp[e.index!] = e.label;
          } else if (e.index == null) {
            // Append non-indexed labels into first available empty slot, then grow if needed.
            while (appendCursor < tmp.length && tmp[appendCursor] != null) {
              appendCursor++;
            }
            if (appendCursor < tmp.length) {
              tmp[appendCursor] = e.label;
            } else {
              tmp.add(e.label);
            }
          }
        }
        _labels = List<String>.generate(
          tmp.length,
          (i) => tmp[i] ?? 'Class $i',
        );
      } else {
        _labels = parsed.map((e) => e.label).toList();
      }
    } catch (_) {
      // Keep empty and let runtime align labels with model output shape.
      _labels = const [];
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
        _interpreter =
            await tflite.Interpreter.fromAsset(AppConfig.MODEL_ASSET_PATH);
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
      _interpreter =
          await tflite.Interpreter.fromAsset(AppConfig.MODEL_ASSET_PATH);
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
      print(
          '⚠️  [TFLiteService] Sử dụng mock inference (model không load được)');
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
      final modeNames = [
        'ImageNet RGB',
        'Simple [0,1] RGB',
        'ImageNet BGR',
        '[-1,1] RGB',
        'No preprocessing (0..255)'
      ];
      print('   Preprocessing: ${modeNames[AppConfig.PREPROCESSING_MODE]}');

      // Determine layout
      final isNHWC =
          inputShape.length == 4 && inputShape[0] == 1 && inputShape[3] == 3;
      final isNCHW =
          inputShape.length == 4 && inputShape[0] == 1 && inputShape[1] == 3;

      final height = isNHWC
          ? inputShape[1]
          : isNCHW
              ? inputShape[2]
              : AppConfig.INPUT_SIZE;
      final width = isNHWC
          ? inputShape[2]
          : isNCHW
              ? inputShape[3]
              : AppConfig.INPUT_SIZE;

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
      const mode = AppConfig.PREPROCESSING_MODE;
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
        const mode = AppConfig.PREPROCESSING_MODE;
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
        output = List<List<double>>.generate(
            1, (_) => List<double>.filled(numClasses, 0.0));
      } else if (outputShape.length == 1) {
        numClasses = outputShape[0];
        output = List<double>.filled(numClasses, 0.0);
      } else {
        // Generic fallback: treat last dim as classes
        numClasses = outputShape.last;
        output = List<List<double>>.generate(
            1, (_) => List<double>.filled(numClasses, 0.0));
      }
      _alignLabelsWithOutput(numClasses);

      // Run inference
      print('🚀 [TFLiteService] Chạy inference...');
      _interpreter!.run(input, output);
      print('   ✅ Inference hoàn tất');

      // Read raw output into 1D list
      final List<double> rawOut =
          output is List<List<double>> ? output[0] : (output as List<double>);
      print(
          '🔍 Raw output (first 5): ${rawOut.take(math.min(5, rawOut.length)).toList()}');
      final probs = AppConfig.OUTPUT_IS_SOFTMAX ? rawOut : _softmax(rawOut);
      print('   📊 Số lượng classes: ${probs.length}');

      final indexed = List.generate(
        probs.length,
        (i) => (index: i, prob: probs[i]),
      )..sort((a, b) => b.prob.compareTo(a.prob));

      print('🔍 Top predictions:');
      for (var i = 0; i < 3 && i < indexed.length; i++) {
        final e = indexed[i];
        final label =
            e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
        print(
            '   [$i] idx=${e.index}, label="$label", conf=${(e.prob * 100).toStringAsFixed(1)}%');
      }

      // Enforce top-K and threshold
      const k = AppConfig.TOP_K <= 0 ? 1 : AppConfig.TOP_K;
      const threshold = AppConfig.CONFIDENCE_THRESHOLD;

      // Always compute the top sorted list for logging/debug
      final topKAll = indexed.take(math.min(3, indexed.length)).map((e) {
        final label =
            e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
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
  /// 3. Kiểm tra confidence threshold (>= 85%)
  /// 4. Kiểm tra tính hợp lệ của nhãn + độ tách biệt top-1/top-2
  /// 5. Kiểm tra out-of-scope detection (mơ hồ dự đoán + leaf-likelihood)
  Future<VerificationResult> runWithVerification(File imageFile) async {
    print('🔒 [TFLiteService] Bắt đầu inference với verification');

    // ✅ BƯỚC 1: Kiểm tra chất lượng ảnh
    print('🔍 [Verification] Kiểm tra chất lượng ảnh...');
    final qualityResult = await _qualityService.checkImageQuality(imageFile);

    if (!qualityResult.isGoodQuality) {
      print(
          '❌ [Verification] Ảnh không đạt chất lượng: ${qualityResult.reason}');
      return VerificationResult.failed(
        error: VerificationError.poorQuality,
        message: qualityResult.reason,
        imageQualityScore: qualityResult.blurScore,
      );
    }

    print(
        '✅ [Verification] Chất lượng ảnh OK (score: ${qualityResult.blurScore.toStringAsFixed(1)})');

    // ✅ BƯỚC 2: Chạy inference
    print('🧠 [Verification] Chạy inference...');
    final inferenceSnapshot = await _runInferenceSnapshot(imageFile);
    final predictions = inferenceSnapshot.topPredictions;

    if (predictions.isEmpty) {
      print('❌ [Verification] Không có kết quả dự đoán');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message: 'Không thể phân tích ảnh',
        imageQualityScore: qualityResult.blurScore,
      );
    }

    final topResult = predictions.first;
    print(
        '🏆 [Verification] Top prediction: ${topResult.label} (${(topResult.confidence * 100).toStringAsFixed(1)}%)');

    // ✅ BƯỚC 2B: Loại trừ class ngoài phạm vi (ví dụ NonLeaf)
    if (_isOutOfScopeLabel(topResult.label)) {
      print('❌ [Verification] Nhãn ngoài phạm vi: ${topResult.label}');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message: 'Ảnh không phải lá cây hoặc ngoài phạm vi mô hình',
        imageQualityScore: qualityResult.blurScore,
      );
    }

    // ✅ BƯỚC 3A: Kiểm tra nhãn có hợp lệ hay không (tránh trả về chỉ tên cây chung chung)
    if (!_isValidPlantDiseaseLabel(topResult.label)) {
      print(
          '❌ [Verification] Nhãn không hợp lệ hoặc quá chung chung: ${topResult.label}');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message: 'Ảnh không thuộc nhóm bệnh/lá cây được hỗ trợ',
        imageQualityScore: qualityResult.blurScore,
      );
    }

    // ✅ BƯỚC 3: Kiểm tra confidence threshold
    const confidenceThreshold =
        AppConfig.LOW_CONFIDENCE_RETAKE_THRESHOLD; // 85%

    if (topResult.confidence < confidenceThreshold) {
      final confidencePct = (topResult.confidence * 100).toStringAsFixed(1);
      final thresholdPct = (confidenceThreshold * 100).toStringAsFixed(1);
      print(
          '⚠️  [Verification] Confidence thấp: ${confidencePct}% < ${thresholdPct}%');
      return VerificationResult.failed(
        error: VerificationError.lowConfidence,
        message:
            'Độ tin cậy mô hình ${confidencePct}% thấp hơn ngưỡng ${thresholdPct}%',
        imageQualityScore: qualityResult.blurScore,
      );
    }

    // ✅ BƯỚC 3B: Kiểm tra độ tách biệt giữa top-1 và top-2
    if (predictions.length >= 2) {
      final gap = predictions[0].confidence - predictions[1].confidence;
      final top1Plant = _extractPlantPrefix(predictions[0].label);
      final top2Plant = _extractPlantPrefix(predictions[1].label);

      // Cặp Tomato Early/Late Blight là cặp dễ nhầm nhất -> yêu cầu gap cao hơn bình thường.
      if (_isTomatoBlightAmbiguousPair(
              predictions[0].label, predictions[1].label) &&
          gap < AppConfig.TOMATO_BLIGHT_AMBIGUITY_GAP) {
        final gapPct = (gap * 100).toStringAsFixed(1);
        final minGapPct =
            (AppConfig.TOMATO_BLIGHT_AMBIGUITY_GAP * 100).toStringAsFixed(1);
        print(
            '⚠️  [Verification] Mơ hồ Tomato blight: gap=${gapPct}% (<${minGapPct}%)');
        return VerificationResult.failed(
          error: VerificationError.lowConfidence,
          message:
              'Mô hình đang phân vân giữa mốc sớm và mốc muộn (${gapPct}%). Vui lòng chụp cận vùng đốm bệnh trên một lá cà chua, đủ sáng, nét và nền đơn giản.',
          imageQualityScore: qualityResult.blurScore,
        );
      }

      // Nếu top-1 và top-2 là 2 cây khác nhau mà điểm quá sát nhau thì coi là mơ hồ.
      if (top1Plant != null &&
          top2Plant != null &&
          top1Plant != top2Plant &&
          gap < AppConfig.CROSS_PLANT_AMBIGUITY_GAP) {
        final gapPct = (gap * 100).toStringAsFixed(1);
        print(
            '⚠️  [Verification] Mơ hồ khác cây: $top1Plant vs $top2Plant, gap=${gapPct}%');
        return VerificationResult.failed(
          error: VerificationError.lowConfidence,
          message:
              'Mô hình đang phân vân giữa 2 loại cây khác nhau (${gapPct}%). Vui lòng chụp sát một lá duy nhất, nền đơn giản và đủ sáng.',
          imageQualityScore: qualityResult.blurScore,
        );
      }

      if (gap < AppConfig.MIN_TOP1_TOP2_GAP) {
        final gapPct = (gap * 100).toStringAsFixed(1);
        final minGapPct =
            (AppConfig.MIN_TOP1_TOP2_GAP * 100).toStringAsFixed(1);
        print('⚠️  [Verification] Dự đoán mơ hồ: gap top1-top2 = ${gapPct}%');
        return VerificationResult.failed(
          error: VerificationError.lowConfidence,
          message:
              'Dự đoán còn mơ hồ: chênh lệch top-1/top-2 là ${gapPct}% (yêu cầu tối thiểu ${minGapPct}%)',
          imageQualityScore: qualityResult.blurScore,
        );
      }
    }

    // ✅ BƯỚC 4A: Kiểm tra khả năng ảnh có chứa lá cây hay không
    final leafColorRatio = await _estimateLeafColorRatio(imageFile);
    print(
        '   🌿 Leaf-like color ratio: ${(leafColorRatio * 100).toStringAsFixed(1)}%');
    if (leafColorRatio < AppConfig.MIN_LEAF_COLOR_RATIO) {
      print('❌ [Verification] Ảnh có dấu hiệu không phải lá cây');
      return VerificationResult.failed(
        error: VerificationError.outOfScope,
        message:
            'Ảnh không giống lá cây. Vui lòng chụp trực tiếp lá cây rõ nét.',
        imageQualityScore: qualityResult.blurScore,
      );
    }

    // ✅ BƯỚC 5: Kiểm tra out-of-scope (OOD detection)
    // Sử dụng entropy và max probability để phát hiện ảnh ngoài phạm vi
    final isOutOfScope =
        _detectOutOfScopeFromProbabilities(inferenceSnapshot.probabilities);

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

  bool _isValidPlantDiseaseLabel(String label) {
    final normalized = label.trim().toLowerCase();
    if (normalized.isEmpty) return false;

    // PlantVillage labels usually follow: Plant___DiseaseName
    if (normalized.contains('___')) {
      final parts = normalized.split('___');
      if (parts.length < 2) return false;
      final plant = parts.first.trim();
      final disease = parts.sublist(1).join('___').trim();
      if (plant.isEmpty || disease.isEmpty) return false;
      return true;
    }

    // Fallback guard: plain labels like just "tomato" are too generic
    const diseaseKeywords = [
      'healthy',
      'blight',
      'spot',
      'rust',
      'mold',
      'virus',
      'scab',
      'rot',
      'mite',
      'measles',
    ];
    return diseaseKeywords.any(normalized.contains);
  }

  Future<double> _estimateLeafColorRatio(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return 0.0;
      final image = img.bakeOrientation(decoded);

      final sampled = img.copyResize(image, width: 224, height: 224);
      var total = 0;
      var leafLike = 0;

      for (var y = 0; y < sampled.height; y += 2) {
        for (var x = 0; x < sampled.width; x += 2) {
          final p = sampled.getPixelSafe(x, y);
          final r = p.r.toDouble();
          final g = p.g.toDouble();
          final b = p.b.toDouble();

          // Excess Green index (common vegetation heuristic)
          final exg = (2 * g) - r - b;
          final isGreenLeaf = exg > 15 && g > 35;

          // Brown/yellow damaged leaf tones (to not reject sick leaves too aggressively)
          final isDryLeafTone = r > 55 && g > 35 && b < 90 && r > g;

          total++;
          if (isGreenLeaf || isDryLeafTone) {
            leafLike++;
          }
        }
      }

      if (total == 0) return 0.0;
      return leafLike / total;
    } catch (_) {
      // Fail-open: if this check fails technically, don't reject image only by this signal.
      return 0.2;
    }
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
      print(
          '   🔍 OOD: Max prob quá thấp (${(topResult.confidence * 100).toStringAsFixed(1)}%)');
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

    print(
        '   🔍 OOD check: entropy=${normalizedEntropy.toStringAsFixed(3)}, maxProb=${(topResult.confidence * 100).toStringAsFixed(1)}%');

    // Nếu entropy > 0.8 (phân bố gần như đều) → likely OOD
    const entropyThreshold = 0.75;
    if (normalizedEntropy > entropyThreshold) {
      print('   🔍 OOD: Entropy cao (${normalizedEntropy.toStringAsFixed(3)})');
      return true;
    }

    // Threshold 3: Gap giữa top-1 và top-2 quá nhỏ
    if (predictions.length >= 2) {
      final gap = topResult.confidence - predictions[1].confidence;
      const minGap = AppConfig.MIN_TOP1_TOP2_GAP;

      if (gap < minGap) {
        print(
            '   🔍 OOD: Gap giữa top-1 và top-2 quá nhỏ (${(gap * 100).toStringAsFixed(1)}%)');
        return true;
      }
    }

    return false;
  }

  Future<_InferenceSnapshot> _runInferenceSnapshot(File imageFile) async {
    print('🖼️  [TFLiteService] Bắt đầu xử lý ảnh');
    print('   📁 Đường dẫn: ${imageFile.path}');

    await loadModel();

    if (_useAndroidMock || _interpreter == null) {
      print(
          '⚠️  [TFLiteService] Sử dụng mock inference (model không load được)');
      final mockPredictions = _runMockInference();
      return _InferenceSnapshot(
        probabilities: mockPredictions.map((e) => e.confidence).toList(),
        topPredictions: mockPredictions,
      );
    }

    try {
      final bytes = await imageFile.readAsBytes();
      var decoded = img.decodeImage(bytes);
      if (decoded == null) {
        throw Exception('Failed to decode image');
      }

      decoded = img.bakeOrientation(decoded);

      final inputTensor = _interpreter!.getInputTensor(0);
      final inputShape = inputTensor.shape;
      final inputTypeStr = inputTensor.type.toString().toLowerCase();
      final isFloatModel = inputTypeStr.contains('float32');

      final isNHWC =
          inputShape.length == 4 && inputShape[0] == 1 && inputShape[3] == 3;
      final isNCHW =
          inputShape.length == 4 && inputShape[0] == 1 && inputShape[1] == 3;

      final height = isNHWC
          ? inputShape[1]
          : isNCHW
              ? inputShape[2]
              : AppConfig.INPUT_SIZE;
      final width = isNHWC
          ? inputShape[2]
          : isNCHW
              ? inputShape[3]
              : AppConfig.INPUT_SIZE;

      final outputShape = _interpreter!.getOutputTensor(0).shape;
      int numClasses;
      if (outputShape.length == 2) {
        numClasses = outputShape[1];
      } else if (outputShape.length == 1) {
        numClasses = outputShape[0];
      } else {
        numClasses = outputShape.last;
      }
      _alignLabelsWithOutput(numClasses);

      final modelViews = _buildModelViews(
        decoded,
        width: width,
        height: height,
      );
      final accumulatedScores = List<double>.filled(numClasses, 0.0);

      for (final modelView in modelViews) {
        final input = _buildInputTensor(
          image: modelView,
          isFloatModel: isFloatModel,
          isNHWC: isNHWC,
          isNCHW: isNCHW,
        );

        dynamic output;
        if (outputShape.length == 2) {
          output = List<List<double>>.generate(
            1,
            (_) => List<double>.filled(numClasses, 0.0),
          );
        } else if (outputShape.length == 1) {
          output = List<double>.filled(numClasses, 0.0);
        } else {
          output = List<List<double>>.generate(
            1,
            (_) => List<double>.filled(numClasses, 0.0),
          );
        }

        _interpreter!.run(input, output);
        final viewScores =
            output is List<List<double>> ? output[0] : (output as List<double>);
        final limit = math.min(accumulatedScores.length, viewScores.length);
        for (var i = 0; i < limit; i++) {
          accumulatedScores[i] += viewScores[i];
        }
      }

      final viewCount = math.max(1, modelViews.length);
      for (var i = 0; i < accumulatedScores.length; i++) {
        accumulatedScores[i] /= viewCount;
      }

      final probabilities = AppConfig.OUTPUT_IS_SOFTMAX
          ? accumulatedScores
          : _softmax(accumulatedScores);
      final indexed = List.generate(
        probabilities.length,
        (i) => (index: i, prob: probabilities[i]),
      )..sort((a, b) => b.prob.compareTo(a.prob));

      final topCandidates = indexed
          .take(math.min(math.max(AppConfig.TOP_K, 3), indexed.length))
          .map((e) {
        final label =
            e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
        return InferenceResult(label: label, confidence: e.prob);
      }).toList();

      if (topCandidates.isEmpty ||
          topCandidates.first.confidence < AppConfig.CONFIDENCE_THRESHOLD) {
        return _InferenceSnapshot(
          probabilities: probabilities,
          topPredictions: const [],
        );
      }

      const resultCount = AppConfig.TOP_K <= 0 ? 1 : AppConfig.TOP_K;
      return _InferenceSnapshot(
        probabilities: probabilities,
        topPredictions: topCandidates.take(resultCount).toList(),
      );
    } catch (e, st) {
      print('❌ Inference snapshot failed: $e\n$st');
      final mockPredictions = _runMockInference();
      return _InferenceSnapshot(
        probabilities: mockPredictions.map((e) => e.confidence).toList(),
        topPredictions: mockPredictions,
      );
    }
  }

  List<img.Image> _buildModelViews(
    img.Image image, {
    required int width,
    required int height,
  }) {
    final views = <img.Image>[];
    final seenCropSizes = <String>{};

    for (final scale in AppConfig.MULTI_CROP_SCALES) {
      final cropped = _cropCenteredSquare(image, scale);
      final cropKey = '${cropped.width}x${cropped.height}';
      if (!seenCropSizes.add(cropKey)) {
        continue;
      }

      views.add(
        img.copyResize(
          cropped,
          width: width,
          height: height,
          interpolation: img.Interpolation.average,
        ),
      );
    }

    if (views.isEmpty) {
      views.add(
        img.copyResize(
          _cropCenteredSquare(image, 1.0),
          width: width,
          height: height,
          interpolation: img.Interpolation.average,
        ),
      );
    }

    return views;
  }

  img.Image _cropCenteredSquare(img.Image image, double scale) {
    final safeScale = scale.clamp(0.5, 1.0);
    final baseSide = math.min(image.width, image.height);
    final cropSide = math.max(1, (baseSide * safeScale).round());
    final maxX = math.max(0, image.width - cropSide);
    final maxY = math.max(0, image.height - cropSide);

    return img.copyCrop(
      image,
      x: (maxX / 2).round(),
      y: (maxY / 2).round(),
      width: cropSide,
      height: cropSide,
    );
  }

  dynamic _buildInputTensor({
    required img.Image image,
    required bool isFloatModel,
    required bool isNHWC,
    required bool isNCHW,
  }) {
    const mode = AppConfig.PREPROCESSING_MODE;
    final width = image.width;
    final height = image.height;

    if (isNHWC) {
      return List.generate(
        1,
        (_) => List.generate(
          height,
          (y) => List.generate(
            width,
            (x) {
              final pixel = image.getPixelSafe(x, y);
              final r = pixel.r.toInt().clamp(0, 255);
              final g = pixel.g.toInt().clamp(0, 255);
              final b = pixel.b.toInt().clamp(0, 255);
              if (isFloatModel) {
                return _preprocessPixel(r, g, b, mode);
              }
              return [r, g, b];
            },
          ),
        ),
      );
    }

    if (isNCHW) {
      return List.generate(
        1,
        (_) => List.generate(
          3,
          (c) => List.generate(
            height,
            (y) => List.generate(
              width,
              (x) {
                final pixel = image.getPixelSafe(x, y);
                final r = pixel.r.toInt().clamp(0, 255);
                final g = pixel.g.toInt().clamp(0, 255);
                final b = pixel.b.toInt().clamp(0, 255);
                if (isFloatModel) {
                  return _preprocessPixel(r, g, b, mode)[c];
                }
                return [r, g, b][c];
              },
            ),
          ),
        ),
      );
    }

    throw Exception('Unsupported input layout');
  }

  bool _detectOutOfScopeFromProbabilities(List<double> probabilities) {
    final rankedPredictions = probabilities
        .map((probability) =>
            InferenceResult(label: '', confidence: probability))
        .toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    return _detectOutOfScope(rankedPredictions);
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
      final label =
          e.index < _labels.length ? _labels[e.index] : 'Class ${e.index}';
      return InferenceResult(label: label, confidence: e.prob);
    }).toList();
  }

  void _alignLabelsWithOutput(int classCount) {
    if (classCount <= 0) return;

    if (_labels.length == classCount) return;

    if (_labels.length < classCount) {
      final filled = List<String>.generate(
        classCount,
        (i) => i < _labels.length ? _labels[i] : 'Class $i',
      );
      _labels = filled;
      print(
          '⚠️  Labels thiếu so với output classes. Auto-fill lên ${_labels.length} nhãn.');
      return;
    }

    _labels = _labels.take(classCount).toList();
    print(
        '⚠️  Labels nhiều hơn output classes. Cắt còn ${_labels.length} nhãn để khớp model.');
  }

  bool _isOutOfScopeLabel(String label) {
    final normalized = label.toLowerCase().replaceAll('_', ' ').trim();
    for (final keyword in AppConfig.OUT_OF_SCOPE_LABEL_KEYWORDS) {
      if (normalized.contains(keyword)) return true;
    }
    return false;
  }

  String? _extractPlantPrefix(String label) {
    final normalized = label.trim();
    if (normalized.isEmpty) return null;
    if (!normalized.contains('___')) return null;

    final plant = normalized.split('___').first.trim().toLowerCase();
    return plant.isEmpty ? null : plant;
  }

  bool _isTomatoBlightAmbiguousPair(String labelA, String labelB) {
    final a = labelA.toLowerCase();
    final b = labelB.toLowerCase();

    bool isTomatoLabel(String s) => s.startsWith('tomato___');
    bool isEarlyBlight(String s) =>
        s.contains('early blight') || s.contains('early_blight');
    bool isLateBlight(String s) =>
        s.contains('late blight') || s.contains('late_blight');

    if (!isTomatoLabel(a) || !isTomatoLabel(b)) return false;

    final aEarlyBLight = isEarlyBlight(a);
    final aLateBlight = isLateBlight(a);
    final bEarlyBlight = isEarlyBlight(b);
    final bLateBlight = isLateBlight(b);

    return (aEarlyBLight && bLateBlight) || (aLateBlight && bEarlyBlight);
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

class _InferenceSnapshot {
  final List<double> probabilities;
  final List<InferenceResult> topPredictions;

  const _InferenceSnapshot({
    required this.probabilities,
    required this.topPredictions,
  });
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

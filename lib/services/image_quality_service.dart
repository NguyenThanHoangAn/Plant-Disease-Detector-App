import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

final imageQualityServiceProvider = Provider<ImageQualityService>((ref) {
  return ImageQualityService();
});

/// Service để kiểm tra chất lượng ảnh
class ImageQualityService {
  /// Kiểm tra độ mờ của ảnh sử dụng Laplacian variance
  /// Trả về score từ 0-100 (càng cao càng rõ nét)
  /// 
  /// Threshold gợi ý:
  /// - < 30: Rất mờ (reject)
  /// - 30-50: Mờ vừa (warning)
  /// - > 50: Rõ nét (accept)
  Future<ImageQualityResult> checkImageQuality(File imageFile) async {
    try {
      print('🔍 [ImageQuality] Đang kiểm tra chất lượng ảnh...');
      
      // Đọc ảnh
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        return ImageQualityResult(
          isGoodQuality: false,
          blurScore: 0,
          reason: 'Không thể đọc ảnh',
        );
      }

      // Resize ảnh xuống để tính toán nhanh hơn (giữ tỷ lệ)
      final resized = _resizeForQualityCheck(image);
      
      // Chuyển sang grayscale
      final gray = img.grayscale(resized);
      
      // Tính Laplacian variance (phát hiện blur)
      final blurScore = _calculateLaplacianVariance(gray);
      
      // Normalize score về 0-100
      final normalizedScore = _normalizeBlurScore(blurScore);
      
      print('   📊 Blur score: ${normalizedScore.toStringAsFixed(1)} (raw: ${blurScore.toStringAsFixed(2)})');
      
      // Đánh giá chất lượng
      final isGoodQuality = normalizedScore >= 30; // Threshold
      final quality = _getQualityLabel(normalizedScore);
      
      print('   ${isGoodQuality ? "✅" : "❌"} Chất lượng: $quality');
      
      return ImageQualityResult(
        isGoodQuality: isGoodQuality,
        blurScore: normalizedScore,
        reason: isGoodQuality ? quality : 'Ảnh quá mờ hoặc không rõ nét',
      );
      
    } catch (e) {
      print('❌ [ImageQuality] Lỗi kiểm tra: $e');
      return ImageQualityResult(
        isGoodQuality: true, // Fail-safe: cho phép tiếp tục nếu lỗi kiểm tra
        blurScore: 50,
        reason: 'Không thể kiểm tra chất lượng',
      );
    }
  }

  /// Resize ảnh để kiểm tra chất lượng nhanh hơn
  img.Image _resizeForQualityCheck(img.Image image) {
    const maxSize = 640;
    
    if (image.width <= maxSize && image.height <= maxSize) {
      return image;
    }
    
    if (image.width > image.height) {
      return img.copyResize(image, width: maxSize);
    } else {
      return img.copyResize(image, height: maxSize);
    }
  }

  /// Tính Laplacian variance để phát hiện blur
  /// Giá trị cao = ảnh rõ nét, giá trị thấp = ảnh mờ
  double _calculateLaplacianVariance(img.Image gray) {
    // Laplacian kernel 3x3
    final kernel = [
      [0, 1, 0],
      [1, -4, 1],
      [0, 1, 0],
    ];
    
    final values = <double>[];
    
    // Áp dụng Laplacian kernel
    for (int y = 1; y < gray.height - 1; y++) {
      for (int x = 1; x < gray.width - 1; x++) {
        double sum = 0;
        
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = gray.getPixel(x + kx, y + ky);
            final intensity = pixel.r.toDouble(); // Grayscale, nên r=g=b
            sum += intensity * kernel[ky + 1][kx + 1];
          }
        }
        
        values.add(sum.abs());
      }
    }
    
    if (values.isEmpty) return 0;
    
    // Tính variance
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
    
    return variance;
  }

  /// Normalize blur score về thang 0-100
  double _normalizeBlurScore(double rawScore) {
    // Raw score thường trong khoảng 0-5000+
    // Map về 0-100 với logarithmic scale
    if (rawScore <= 0) return 0;
    
    // Sử dụng log scale để normalize
    final normalized = math.min(100.0, (math.log(rawScore + 1) / math.log(5000)) * 100);
    return normalized;
  }

  /// Lấy nhãn chất lượng dựa trên score
  String _getQualityLabel(double score) {
    if (score >= 70) return 'Rất tốt';
    if (score >= 50) return 'Tốt';
    if (score >= 30) return 'Trung bình';
    if (score >= 15) return 'Kém';
    return 'Rất kém';
  }
}

/// Kết quả kiểm tra chất lượng ảnh
class ImageQualityResult {
  final bool isGoodQuality;
  final double blurScore; // 0-100, càng cao càng rõ
  final String reason;

  ImageQualityResult({
    required this.isGoodQuality,
    required this.blurScore,
    required this.reason,
  });

  @override
  String toString() {
    return 'ImageQualityResult(isGood: $isGoodQuality, score: ${blurScore.toStringAsFixed(1)}, reason: $reason)';
  }
}

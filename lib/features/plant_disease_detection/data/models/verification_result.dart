import 'inference_result.dart';

/// Enum cho các loại lỗi verification
enum VerificationError {
  none,
  outOfScope, // Ảnh ngoài phạm vi hỗ trợ
  lowConfidence, // Độ tin cậy thấp
  poorQuality, // Chất lượng ảnh kém
}

/// Kết quả sau khi verify ảnh và inference
class VerificationResult {
  final bool isPassed; // True nếu pass tất cả verification
  final VerificationError error; // Loại lỗi nếu có
  final List<InferenceResult> predictions; // Kết quả dự đoán (có thể empty nếu failed)
  final double? imageQualityScore; // Điểm chất lượng ảnh (0-100)
  final String? message; // Message mô tả lỗi
  final bool isWarning; // True nếu là cảnh báo nhưng vẫn cho phép hiển thị kết quả

  VerificationResult({
    required this.isPassed,
    required this.error,
    required this.predictions,
    this.imageQualityScore,
    this.message,
    this.isWarning = false,
  });

  /// Constructor cho trường hợp pass
  factory VerificationResult.passed({
    required List<InferenceResult> predictions,
    double? imageQualityScore,
  }) {
    return VerificationResult(
      isPassed: true,
      error: VerificationError.none,
      predictions: predictions,
      imageQualityScore: imageQualityScore,
      isWarning: false,
    );
  }

  /// Constructor cho trường hợp warning (vẫn pass nhưng cần cảnh báo người dùng)
  factory VerificationResult.warning({
    required List<InferenceResult> predictions,
    VerificationError error = VerificationError.lowConfidence,
    String? message,
    double? imageQualityScore,
  }) {
    return VerificationResult(
      isPassed: true,
      error: error,
      predictions: predictions,
      imageQualityScore: imageQualityScore,
      message: message,
      isWarning: true,
    );
  }

  /// Constructor cho trường hợp failed
  factory VerificationResult.failed({
    required VerificationError error,
    String? message,
    double? imageQualityScore,
  }) {
    return VerificationResult(
      isPassed: false,
      error: error,
      predictions: [],
      imageQualityScore: imageQualityScore,
      message: message,
      isWarning: false,
    );
  }

  /// Kiểm tra xem có phải lỗi chất lượng ảnh không
  bool get isPoorQuality => error == VerificationError.poorQuality;

  /// Kiểm tra xem có phải lỗi ngoài phạm vi không
  bool get isOutOfScope => error == VerificationError.outOfScope;

  /// Kiểm tra xem có phải lỗi độ tin cậy thấp không
  bool get isLowConfidence => error == VerificationError.lowConfidence;

  /// Lấy kết quả hàng đầu (nếu có)
  InferenceResult? get topResult {
    if (predictions.isEmpty) return null;
    return predictions.first;
  }

  @override
  String toString() {
    if (isPassed) {
      return 'VerificationResult.passed(predictions: ${predictions.length}, quality: $imageQualityScore)';
    } else {
      return 'VerificationResult.failed(error: $error, message: $message)';
    }
  }
}

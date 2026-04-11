class AppConfig {
  /// Đường dẫn tới file model TFLite đã copy vào assets/models/
  static const String MODEL_ASSET_PATH = 'assets/models/plant_disease_model.tflite';

  /// Kích thước input mặc định; sẽ được override nếu model báo shape khác.
  static const int INPUT_SIZE = 224;
  
  /// Preprocessing mode for building model inputs
  /// 0 = ImageNet (mean/std) with RGB
  /// 1 = Simple [0,1] normalize with RGB  
  /// 2 = ImageNet with BGR (swap R-B channels)
  /// 3 = [-1,1] normalize with RGB
  /// 4 = No preprocessing (0..255 floats, RGB) – use when preprocessing embedded in model
  static const int PREPROCESSING_MODE = 1; // Thử Simple [0,1] normalize

  /// Model output already softmax probabilities (true) or logits (false)
  static const bool OUTPUT_IS_SOFTMAX = true;

  /// Post-processing: threshold for accepting prediction, and top-K to return
  static const double CONFIDENCE_THRESHOLD = 0.10; // Giảm threshold để nhận diện linh hoạt hơn
  static const int TOP_K = 3; // Hiển thị top 3 kết quả

  /// Verification threshold: only ask user to retake if confidence is below this value
  static const double LOW_CONFIDENCE_RETAKE_THRESHOLD = 0.85; // 85%

  /// Extra verification thresholds to reduce false positives.
  static const double MIN_TOP1_TOP2_GAP = 0.18; // top-1 must exceed top-2 by at least 18%
  static const double MIN_LEAF_COLOR_RATIO = 0.08; // basic leaf-like color ratio
}

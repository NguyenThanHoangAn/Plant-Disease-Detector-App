class AppConfig {
  /// Đường dẫn tới file model TFLite đã copy vào assets/models/
  static const String MODEL_ASSET_PATH =
      'assets/models/plant_disease_model.tflite';

  /// Đường dẫn tới danh sách nhãn tương ứng theo index output của model.
  static const String LABELS_ASSET_PATH = 'assets/models/labels.txt';

  /// Kích thước input mặc định; sẽ được override nếu model báo shape khác.
  static const int INPUT_SIZE = 224;

  /// Preprocessing mode for building model inputs
  /// 0 = ImageNet (mean/std) with RGB
  /// 1 = Simple [0,1] normalize with RGB
  /// 2 = ImageNet with BGR (swap R-B channels)
  /// 3 = [-1,1] normalize with RGB
  /// 4 = No preprocessing (0..255 floats, RGB) – use when model expects raw pixel range
  static const int PREPROCESSING_MODE =
      4; // Current model expects raw pixel range 0..255

  /// Model output already softmax probabilities (true) or logits (false)
  static const bool OUTPUT_IS_SOFTMAX = true;

  /// Post-processing: threshold for accepting prediction, and top-K to return
  static const double CONFIDENCE_THRESHOLD =
      0.60; // Không trả về prediction dưới 60%
  static const int TOP_K = 3; // Hiển thị top 3 kết quả

  /// Gap tối thiểu giữa top-1 và top-2 để tránh dự đoán mơ hồ.
  static const double MIN_TOP1_TOP2_GAP =
      0.20; // top-1 should exceed top-2 by at least 20%
  static const double MIN_LEAF_COLOR_RATIO =
      0.10; // basic leaf-like color ratio

  /// Test-time augmentation for camera/gallery images.
  /// Scale 1.0 = full centered square, lower values zoom further into leaf.
  static const List<double> MULTI_CROP_SCALES = [1.0, 0.92, 0.84];

  /// Các nhãn được xem là ngoài phạm vi chẩn đoán bệnh lá cây.
  static const List<String> OUT_OF_SCOPE_LABEL_KEYWORDS = [
    'nonleaf',
    'non leaf',
    'background',
    'unknown',
  ];

  /// ==================== DEBUG & STABILITY TUNING ====================
  /// Bật mode debug để xem chi tiết log từng crop confidence, gap, entropy
  static const bool DEBUG_MODE = true; // Set false để ẩn log chi tiết

  /// Bật/tắt multi-crop TTA (Test-Time Augmentation)
  /// true = chạy 3 crop, trung bình kết quả (ổn định hơn nhưng chậm)
  /// false = chỉ chạy 1 crop giữa (nhanh nhưng có thể mình bạc)
  static const bool ENABLE_MULTI_CROP = true;

  /// Log level cho inference:
  /// 0 = Tối thiểu (chỉ error)
  /// 1 = Bình thường (warning + info)
  /// 2 = Chi tiết (tất cả + confidence từng crop)
  /// 3 = Rất chi tiết (dump tất cả probabilities)
  static const int INFERENCE_LOG_LEVEL = 2;
}

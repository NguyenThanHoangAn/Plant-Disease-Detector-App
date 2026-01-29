class AppConfig {
  /// Đường dẫn tới file model TFLite đã copy vào assets/models/
  static const String modelAssetPath = 'assets/models/plant_disease_model.tflite';

  /// Kích thước input mặc định; sẽ được override nếu model báo shape khác.
  static const int inputSize = 224;
  
  /// Preprocessing mode for building model inputs
  /// 0 = ImageNet (mean/std) with RGB
  /// 1 = Simple [0,1] normalize with RGB  
  /// 2 = ImageNet with BGR (swap R-B channels)
  /// 3 = [-1,1] normalize with RGB
  /// 4 = No preprocessing (0..255 floats, RGB) – use when preprocessing embedded in model
  static const int preprocessingMode = 1; // Thử Simple [0,1] normalize

  /// Model output already softmax probabilities (true) or logits (false)
  static const bool outputIsSoftmax = true;

  /// Post-processing: threshold for accepting prediction, and top-K to return
  static const double confidenceThreshold = 0.10; // Giảm threshold để nhận diện linh hoạt hơn
  static const int topK = 3; // Hiển thị top 3 kết quả
}

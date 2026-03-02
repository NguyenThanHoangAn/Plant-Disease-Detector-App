/// Repository quản lý thông tin về các loại cây và bệnh được hỗ trợ
class PlantDiseaseRepository {
  /// Map từ plant key → list of disease labels
  static const Map<String, List<String>> _plantDiseases = {
    'tomato': [
      'Tomato___Bacterial_spot',
      'Tomato___Early Blight',
      'Tomato___Late Blight',
      'Tomato___Leaf_Mold',
      'Tomato___Septoria Leaf Spot',
      'Tomato___Spider_mites Two-spotted_spider_mite',
      'Tomato___Target_Spot',
      'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
      'Tomato___Tomato_mosaic_virus',
      'Tomato___Healthy',
    ],
    'grape': [
      'Grape___Black_rot',
      'Grape___Esca_(Black_Measles)',
      'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
      'Grape___healthy',
    ],
    'potato': [
      'Potato___Early_blight',
      'Potato___Late_blight',
      'Potato___healthy',
    ],
    'apple': [
      'Apple___Apple_scab',
      'Apple___Black_rot',
      'Apple___Cedar_apple_rust',
      'Apple___healthy',
    ],
    'corn': [
      'Corn___Cercospora_leaf_spot Gray_leaf_spot',
      'Corn___Common_rust',
      'Corn___Northern_Leaf_Blight',
      'Corn___healthy',
    ],
  };

  /// Lấy danh sách bệnh của một loại cây
  static List<String> getDiseasesForPlant(String plantKey) {
    return _plantDiseases[plantKey] ?? [];
  }

  /// Lấy danh sách tất cả các loại cây được hỗ trợ
  static List<String> getSupportedPlants() {
    return _plantDiseases.keys.toList();
  }

  /// Kiểm tra xem một loại cây có được hỗ trợ không
  static bool isPlantSupported(String plantKey) {
    return _plantDiseases.containsKey(plantKey);
  }

  /// Lấy số lượng bệnh của một loại cây
  static int getDiseaseCount(String plantKey) {
    return _plantDiseases[plantKey]?.length ?? 0;
  }

  /// Lấy emoji cho từng loại cây
  static String getPlantEmoji(String plantKey) {
    switch (plantKey) {
      case 'tomato':
        return '🍅';
      case 'grape':
        return '🍇';
      case 'potato':
        return '🥔';
      case 'apple':
        return '🍎';
      case 'corn':
        return '🌽';
      default:
        return '🌱';
    }
  }

  /// Lấy tên khoa học
  static String getScientificName(String plantKey) {
    switch (plantKey) {
      case 'tomato':
        return 'Solanum lycopersicum';
      case 'grape':
        return 'Vitis vinifera';
      case 'potato':
        return 'Solanum tuberosum';
      case 'apple':
        return 'Malus domestica';
      case 'corn':
        return 'Zea mays';
      default:
        return '';
    }
  }
}

// Data models and collections for bilingual disease information

class BilingualText {
  final String vi;
  final String en;

  const BilingualText(this.vi, this.en);

  String getLocalized(String locale) => locale == 'vi' ? vi : en;
}

class DiseaseInfo {
  final BilingualText plantName;
  final BilingualText diseaseName;
  final BilingualText description;
  final List<BilingualText> symptoms;
  final List<BilingualText> causes;
  final List<BilingualText> preventionTips;
  final List<BilingualText> organicTreatments;
  final List<BilingualText> chemicalTreatments;
  final List<BilingualText> culturalPractices;

  const DiseaseInfo({
    required this.plantName,
    required this.diseaseName,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.preventionTips,
    required this.organicTreatments,
    required this.chemicalTreatments,
    required this.culturalPractices,
  });
}

// Disease data repository
class DiseaseDataRepository {
  static const Map<String, BilingualText> _plantNameByLabelPrefix = {
    'apple': BilingualText('Táo', 'Apple'),
    'corn': BilingualText('Ngô', 'Corn'),
    'grape': BilingualText('Nho', 'Grape'),
    'potato': BilingualText('Khoai tây', 'Potato'),
    'tomato': BilingualText('Cà chua', 'Tomato'),
  };

  static final Map<String, DiseaseInfo> _diseaseData = {
    'healthy': const DiseaseInfo(
      plantName: BilingualText('Cây', 'Plant'),
      diseaseName: BilingualText('Khỏe mạnh', 'Healthy'),
      description: BilingualText(
        'Cây của bạn khỏe mạnh! Tiếp tục chăm sóc tốt.',
        'Your plant is healthy! Keep up the good work.',
      ),
      symptoms: [
        BilingualText(
          'Tán lá xanh tươi',
          'Vibrant green foliage',
        ),
        BilingualText(
          'Không có đốm hoặc vết thương nào',
          'No visible spots or lesions',
        ),
        BilingualText(
          'Phát triển mạnh mẽ, thẳng đứng',
          'Strong, upright growth',
        ),
        BilingualText(
          'Quả phát triển tốt',
          'Good fruit development',
        ),
        BilingualText(
          'Không có dấu hiệu héo hoặc đổi màu',
          'No signs of wilting or discoloration',
        ),
      ],
      causes: [
        BilingualText(
          'Thực hành canh tác đúng cách',
          'Proper cultural practices',
        ),
        BilingualText(
          'Dinh dưỡng và tưới nước đầy đủ',
          'Adequate nutrition and watering',
        ),
        BilingualText(
          'Các biện pháp phòng ngừa bệnh tốt',
          'Good disease prevention measures',
        ),
        BilingualText(
          'Môi trường phát triển lành mạnh',
          'Healthy growing environment',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Tiếp tục theo dõi sức khỏe cây thường xuyên',
          'Continue regular monitoring of plant health',
        ),
        BilingualText(
          'Duy trì lịch tưới nước và bón phân hợp lý',
          'Maintain proper watering and fertilization schedule',
        ),
        BilingualText(
          'Đảm bảo lưu thông không khí tốt xung quanh cây',
          'Ensure good air circulation around plants',
        ),
        BilingualText(
          'Thực hiện luân canh hàng năm',
          'Practice crop rotation annually',
        ),
        BilingualText(
          'Loại bỏ mảnh vụn thực vật kịp thời',
          'Remove plant debris promptly',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Tiếp tục cải tạo đất hữu cơ',
          'Continue organic soil amendments',
        ),
        BilingualText(
          'Sử dụng trà compost để bổ sung dinh dưỡng',
          'Use compost tea for plant nutrition',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Apply beneficial microorganisms',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Không cần xịt thuốc diệt nấm phòng ngừa',
          'Preventive fungicide applications not needed',
        ),
        BilingualText(
          'Chỉ sử dụng nếu áp lực bệnh cao trong khu vực',
          'Use only if disease pressure is high in area',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Duy trì các phương pháp tốt hiện tại',
          'Maintain current good practices',
        ),
        BilingualText(
          'Tiếp tục theo dõi thường xuyên',
          'Continue regular monitoring',
        ),
        BilingualText(
          'Giữ khu vực trồng trọt sạch sẽ',
          'Keep growing area clean',
        ),
      ],
    ),
    'early_blight': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Mốc sớm', 'Early Blight'),
      description: BilingualText(
        'Bệnh mốc sớm là bệnh nấm phổ biến gây đốm lá và giảm năng suất.',
        'Early blight is a common fungal disease causing leaf spots and reduced yields.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm nâu sẫm đến đen có vòng đồng tâm (hình bia) trên lá già',
          'Dark brown to black spots with concentric rings (target-like pattern) on older leaves',
        ),
        BilingualText(
          'Lá vàng xung quanh các đốm',
          'Yellowing of leaf tissue around the spots',
        ),
        BilingualText(
          'Lá rụng bắt đầu từ phía dưới cây và di chuyển lên trên',
          'Leaf drop starts from bottom of plant and moves upward',
        ),
        BilingualText(
          'Các vết thương trên thân và quả ở giai đoạn tiến triển',
          'Lesions on stems and fruits in advanced stages',
        ),
        BilingualText(
          'Giảm sức sống và năng suất của cây',
          'Reduced plant vigor and yield',
        ),
      ],
      causes: [
        BilingualText(
          'Nhiễm nấm Alternaria solani',
          'Fungal infection by Alternaria solani',
        ),
        BilingualText(
          'Nhiệt độ ấm (24-29°C) với độ ẩm cao',
          'Warm temperatures (24-29°C) with high humidity',
        ),
        BilingualText(
          'Thời gian ướt kéo dài trên lá (mưa, sương, tưới)',
          'Extended wet periods on leaves (rain, dew, irrigation)',
        ),
        BilingualText(
          'Lưu thông không khí kém và khoảng cách cây không đủ',
          'Poor air circulation and plant spacing',
        ),
        BilingualText(
          'Thiếu dinh dưỡng, đặc biệt là nitơ',
          'Nutrient deficiency, especially nitrogen',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'late_blight': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Mốc muộn', 'Late Blight'),
      description: BilingualText(
        'Bệnh mốc muộn là bệnh nấm phá hoại nhanh chóng, có khả năng tiêu diệt toàn bộ mùa màng.',
        'Late blight is a rapidly destructive fungal disease that can wipe out entire crops.',
      ),
      symptoms: [
        BilingualText(
          'Vết thương thấm nước trên lá và thân',
          'Water-soaked lesions on leaves and stems',
        ),
        BilingualText(
          'Nấm mốc trắng mờ mọc ở mặt dưới lá',
          'White fuzzy fungal growth on leaf undersides',
        ),
        BilingualText(
          'Nâu và chết nhanh chóng của mô bị nhiễm',
          'Rapid browning and death of infected tissues',
        ),
        BilingualText(
          'Vết thương nâu sẫm trên quả',
          'Dark brown lesions on fruit',
        ),
        BilingualText(
          'Mùi ẩm mốc đặc trưng từ cây bị nhiễm',
          'Characteristic musty odor from infected plants',
        ),
      ],
      causes: [
        BilingualText(
          'Nhiễm nấm Phytophthora infestans',
          'Fungal infection by Phytophthora infestans',
        ),
        BilingualText(
          'Điều kiện thời tiết mát mẻ, ẩm ướt',
          'Cool, wet weather conditions',
        ),
        BilingualText(
          'Độ ẩm cao (trên 90%)',
          'High humidity (above 90%)',
        ),
        BilingualText(
          'Củ giống hoặc cây con bị nhiễm bệnh',
          'Infected seed tubers or transplants',
        ),
        BilingualText(
          'Bào tử bay từ cây bị nhiễm gần đó',
          'Wind-borne spores from nearby infected plants',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'septoria_leaf_spot': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Đốm lá Septoria', 'Septoria Leaf Spot'),
      description: BilingualText(
        'Bệnh đốm lá Septoria gây ra các vết đốm đặc trưng và rụng lá.',
        'Septoria leaf spot causes distinctive spotting patterns and defoliation.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm tròn nhỏ có tâm xám và viền sẫm',
          'Small circular spots with gray centers and dark borders',
        ),
        BilingualText(
          'Đốm xuất hiện đầu tiên ở lá phía dưới',
          'Spots appear first on lower leaves',
        ),
        BilingualText(
          'Lá vàng và rụng khi bị nhiễm',
          'Yellowing and dropping of infected leaves',
        ),
        BilingualText(
          'Các chấm đen nhỏ (cơ quan sinh sản nấm) ở tâm đốm',
          'Tiny black dots (fungal fruiting bodies) in spot centers',
        ),
        BilingualText(
          'Rụng lá nghiêm trọng ở giai đoạn tiến triển',
          'Severe defoliation in advanced stages',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'bacterial_spot': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Đốm vi khuẩn', 'Bacterial Spot'),
      description: BilingualText(
        'Bệnh đốm vi khuẩn gây hư hại nghiêm trọng cho lá và quả.',
        'Bacterial spot causes severe damage to leaves and fruits.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm nhỏ, sẫm, trông như dầu mỡ trên lá',
          'Small, dark, greasy-looking spots on leaves',
        ),
        BilingualText(
          'Đốm có thể có vầng hào vàng',
          'Spots may have yellow halos',
        ),
        BilingualText(
          'Vết thương nâu nổi lên trên quả',
          'Raised brown lesions on fruits',
        ),
        BilingualText(
          'Lá biến dạng và cuộn lại',
          'Leaf distortion and curling',
        ),
        BilingualText(
          'Lá rụng sớm',
          'Premature leaf drop',
        ),
      ],
      causes: [
        BilingualText(
          'Nhiễm vi khuẩn Xanthomonas',
          'Bacterial infection by Xanthomonas species',
        ),
        BilingualText(
          'Điều kiện ấm áp, ẩm ướt',
          'Warm, humid conditions',
        ),
        BilingualText(
          'Nước bắn từ mưa hoặc tưới phun trên cao',
          'Water splash from rain or overhead irrigation',
        ),
        BilingualText(
          'Hạt giống hoặc cây con bị nhiễm',
          'Contaminated seeds or transplants',
        ),
        BilingualText(
          'Vết thương từ tỉa cành hoặc côn trùng gây hại',
          'Wounds from pruning or insect damage',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt khuẩn gốc đồng',
          'Copper-based bactericides',
        ),
        BilingualText(
          'Xịt streptomycin (nơi được phép)',
          'Streptomycin sprays (where permitted)',
        ),
        BilingualText(
          'Sản phẩm đồng cố định',
          'Fixed copper products',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'leaf_mold': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Nấm lá', 'Leaf Mold'),
      description: BilingualText(
        'Bệnh mốc lá phát triển trong điều kiện ẩm ướt với lưu thông không khí kém.',
        'Leaf mold thrives in humid conditions with poor air circulation.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm xanh nhạt đến vàng trên mặt trên lá',
          'Pale green to yellow spots on upper leaf surfaces',
        ),
        BilingualText(
          'Mốc màu xanh ô-liu đến nâu ở mặt dưới lá',
          'Olive-green to brown mold on leaf undersides',
        ),
        BilingualText(
          'Lá cuộn và héo',
          'Leaf curling and wilting',
        ),
        BilingualText(
          'Lá rụng sớm',
          'Premature leaf drop',
        ),
        BilingualText(
          'Giảm chất lượng và năng suất quả',
          'Reduced fruit quality and yield',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'target_spot': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Đốm bia', 'Target Spot'),
      description: BilingualText(
        'Bệnh đốm đích gây ra các vết đốm đồng tâm đặc trưng.',
        'Target spot causes distinctive concentric ring patterns.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm nâu tròn có vòng đồng tâm',
          'Circular brown spots with concentric rings',
        ),
        BilingualText(
          'Các đốm mở rộng và hợp nhất lại',
          'Spots enlarge and merge together',
        ),
        BilingualText(
          'Vàng xung quanh vết thương',
          'Yellowing around lesions',
        ),
        BilingualText(
          'Ảnh hưởng lá, thân và quả',
          'Affects leaves, stems, and fruits',
        ),
        BilingualText(
          'Rụng lá trong trường hợp nghiêm trọng',
          'Defoliation in severe cases',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'mosaic_virus': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Virus khảm', 'Mosaic Virus'),
      description: BilingualText(
        'Virus khảm lá gây ra hoa văn lá đặc trưng và phát triển kém.',
        'Mosaic virus causes distinctive leaf patterns and stunted growth.',
      ),
      symptoms: [
        BilingualText(
          'Hoa văn màu xanh nhạt và đậm đốm trên lá',
          'Mottled light and dark green patterns on leaves',
        ),
        BilingualText(
          'Lá biến dạng và cuộn lại',
          'Leaf distortion and curling',
        ),
        BilingualText(
          'Cây phát triển bị còi cọc',
          'Stunted plant growth',
        ),
        BilingualText(
          'Giảm kích thước và chất lượng quả',
          'Reduced fruit size and quality',
        ),
        BilingualText(
          'Vệt vàng trên lá',
          'Yellow streaking on leaves',
        ),
      ],
      causes: [
        BilingualText(
          'Nhiễm virus lây truyền qua côn trùng',
          'Viral infection transmitted by insects',
        ),
        BilingualText(
          'Cây con hoặc hạt giống bị nhiễm',
          'Infected transplants or seeds',
        ),
        BilingualText(
          'Rệp hoặc ruồi trắng là vật trung gian',
          'Aphids or whiteflies as vectors',
        ),
        BilingualText(
          'Dụng cụ làm vườn bị nhiễm',
          'Contaminated gardening tools',
        ),
        BilingualText(
          'Tiếp xúc vật lý giữa các cây',
          'Physical contact between plants',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Loại bỏ và tiêu hủy cây bị nhiễm ngay lập tức',
          'Remove and destroy infected plants immediately',
        ),
        BilingualText(
          'Kiểm soát côn trùng trung gian bằng dầu neem',
          'Control insect vectors with neem oil',
        ),
        BilingualText(
          'Sử dụng mulch phản quang để ngăn côn trùng',
          'Use reflective mulches to deter insects',
        ),
        BilingualText(
          'Không có cách chữa - tập trung vào phòng ngừa',
          'No cure available - focus on prevention',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Không có thuốc hóa học chữa bệnh virus',
          'No chemical cure available for viral diseases',
        ),
        BilingualText(
          'Sử dụng thuốc trừ sâu hệ thống để kiểm soát vật trung gian',
          'Use systemic insecticides to control vectors',
        ),
        BilingualText(
          'Imidacloprid để kiểm soát ruồi trắng/rệp',
          'Imidacloprid for whitefly/aphid control',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'yellow_leaf_curl': const DiseaseInfo(
      plantName: BilingualText('Cà chua', 'Tomato'),
      diseaseName: BilingualText('Cuốn lá vàng', 'Yellow Leaf Curl'),
      description: BilingualText(
        'Virus cuộn lá vàng gây ra lá cuộn nghiêm trọng và phát triển kém.',
        'Yellow leaf curl virus causes severe leaf curling and stunted growth.',
      ),
      symptoms: [
        BilingualText(
          'Rìa lá cuộn lên trên',
          'Upward curling of leaf margins',
        ),
        BilingualText(
          'Lá chuyển vàng',
          'Yellowing of leaves',
        ),
        BilingualText(
          'Cây phát triển bị còi cọc nghiêm trọng',
          'Severely stunted plant growth',
        ),
        BilingualText(
          'Giảm hoặc không có sản lượng quả',
          'Reduced or no fruit production',
        ),
        BilingualText(
          'Lá biến dạng và giòn',
          'Leaf distortion and brittleness',
        ),
      ],
      causes: [
        BilingualText(
          'Nhiễm virus lây truyền qua côn trùng',
          'Viral infection transmitted by insects',
        ),
        BilingualText(
          'Cây con hoặc hạt giống bị nhiễm',
          'Infected transplants or seeds',
        ),
        BilingualText(
          'Rệp hoặc ruồi trắng là vật trung gian',
          'Aphids or whiteflies as vectors',
        ),
        BilingualText(
          'Dụng cụ làm vườn bị nhiễm',
          'Contaminated gardening tools',
        ),
        BilingualText(
          'Tiếp xúc vật lý giữa các cây',
          'Physical contact between plants',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Loại bỏ và tiêu hủy cây bị nhiễm ngay lập tức',
          'Remove and destroy infected plants immediately',
        ),
        BilingualText(
          'Kiểm soát côn trùng trung gian bằng dầu neem',
          'Control insect vectors with neem oil',
        ),
        BilingualText(
          'Sử dụng mulch phản quang để ngăn côn trùng',
          'Use reflective mulches to deter insects',
        ),
        BilingualText(
          'Không có cách chữa - tập trung vào phòng ngừa',
          'No cure available - focus on prevention',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Không có thuốc hóa học chữa bệnh virus',
          'No chemical cure available for viral diseases',
        ),
        BilingualText(
          'Sử dụng thuốc trừ sâu hệ thống để kiểm soát vật trung gian',
          'Use systemic insecticides to control vectors',
        ),
        BilingualText(
          'Imidacloprid để kiểm soát ruồi trắng/rệp',
          'Imidacloprid for whitefly/aphid control',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'scab': const DiseaseInfo(
      plantName: BilingualText('Táo', 'Apple'),
      diseaseName: BilingualText('Đốm sẹo', 'Scab'),
      description: BilingualText(
        'Bệnh vảy gây ra các vết thương thô ráp, chai sần trên quả và lá.',
        'Scab disease causes rough, corky lesions on fruits and leaves.',
      ),
      symptoms: [
        BilingualText(
          'Vết thương thô ráp, chai sần trên quả và lá',
          'Rough, corky lesions on fruit and leaves',
        ),
        BilingualText(
          'Các đốm nhung màu xanh ô-liu đến nâu',
          'Olive-green to brown velvety spots',
        ),
        BilingualText(
          'Quả nứt và biến dạng',
          'Cracked and distorted fruit',
        ),
        BilingualText(
          'Quả rụng sớm',
          'Premature fruit drop',
        ),
        BilingualText(
          'Giảm chất lượng quả',
          'Reduced fruit quality',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'black_rot': const DiseaseInfo(
      plantName: BilingualText('Nho', 'Grape'),
      diseaseName: BilingualText('Thối đen', 'Black Rot'),
      description: BilingualText(
        'Bệnh thối đen gây hư hại nghiêm trọng cho quả và lá.',
        'Black rot causes severe damage to fruits and leaves.',
      ),
      symptoms: [
        BilingualText(
          'Các đốm nâu tròn có viền sẫm trên lá',
          'Circular brown spots with dark borders on leaves',
        ),
        BilingualText(
          'Vết thương đen lõm trên quả',
          'Black, sunken lesions on fruit',
        ),
        BilingualText(
          'Quả bị xác ướp hóa',
          'Fruit mummification',
        ),
        BilingualText(
          'Vết loét trên thân và cành',
          'Cankers on stems and branches',
        ),
        BilingualText(
          'Lá và quả rụng sớm',
          'Premature leaf and fruit drop',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'rust': const DiseaseInfo(
      plantName: BilingualText('Cây', 'Plant'),
      diseaseName: BilingualText('Gỉ sắt', 'Rust'),
      description: BilingualText(
        'Bệnh gỉ sắt gây ra các mụn nổi màu cam hoặc nâu đỏ đặc trưng.',
        'Rust disease causes distinctive orange or reddish-brown pustules.',
      ),
      symptoms: [
        BilingualText(
          'Mụn nổi màu cam hoặc nâu đỏ trên bề mặt lá',
          'Orange or reddish-brown pustules on leaf surfaces',
        ),
        BilingualText(
          'Các đốm vàng trên mặt trên lá',
          'Yellow spots on upper leaf surfaces',
        ),
        BilingualText(
          'Lá rụng sớm',
          'Premature leaf drop',
        ),
        BilingualText(
          'Giảm quang hợp',
          'Reduced photosynthesis',
        ),
        BilingualText(
          'Sức sống cây suy yếu',
          'Weakened plant vigor',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'esca': const DiseaseInfo(
      plantName: BilingualText('Nho', 'Grape'),
      diseaseName: BilingualText('Esca', 'Esca'),
      description: BilingualText(
        'Bệnh Esca là bệnh nấm phức tạp ảnh hưởng đến cây nho.',
        'Esca is a complex fungal disease affecting grapevines.',
      ),
      symptoms: [
        BilingualText(
          'Quan sát cây để tìm các đốm bất thường, đổi màu hoặc vết thương',
          'Observe plants for unusual spots, discoloration, or lesions',
        ),
        BilingualText(
          'Theo dõi sự thay đổi màu sắc hoặc kết cấu của lá',
          'Monitor for changes in leaf color or texture',
        ),
        BilingualText(
          'Kiểm tra các kiểu phát triển bất thường',
          'Check for abnormal growth patterns',
        ),
        BilingualText(
          'Tìm dấu hiệu héo hoặc rủ xuống',
          'Look for signs of wilting or drooping',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'blight': const DiseaseInfo(
      plantName: BilingualText('Cây', 'Plant'),
      diseaseName: BilingualText('Héo úa', 'Blight'),
      description: BilingualText(
        'Bệnh chết khô là thuật ngữ chung cho nhiều bệnh gây tàn phá nhanh chóng.',
        'Blight is a general term for various rapidly destructive diseases.',
      ),
      symptoms: [
        BilingualText(
          'Quan sát cây để tìm các đốm bất thường, đổi màu hoặc vết thương',
          'Observe plants for unusual spots, discoloration, or lesions',
        ),
        BilingualText(
          'Theo dõi sự thay đổi màu sắc hoặc kết cấu của lá',
          'Monitor for changes in leaf color or texture',
        ),
        BilingualText(
          'Kiểm tra các kiểu phát triển bất thường',
          'Check for abnormal growth patterns',
        ),
        BilingualText(
          'Tìm dấu hiệu héo hoặc rủ xuống',
          'Look for signs of wilting or drooping',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
    'cercospora_leaf_spot': const DiseaseInfo(
      plantName: BilingualText('Cây', 'Plant'),
      diseaseName: BilingualText('Đốm lá Cercospora', 'Cercospora Leaf Spot'),
      description: BilingualText(
        'Bệnh đốm lá Cercospora gây ra các đốm lá và giảm năng suất.',
        'Cercospora leaf spot causes leaf spotting and reduced yields.',
      ),
      symptoms: [
        BilingualText(
          'Quan sát cây để tìm các đốm bất thường, đổi màu hoặc vết thương',
          'Observe plants for unusual spots, discoloration, or lesions',
        ),
        BilingualText(
          'Theo dõi sự thay đổi màu sắc hoặc kết cấu của lá',
          'Monitor for changes in leaf color or texture',
        ),
        BilingualText(
          'Kiểm tra các kiểu phát triển bất thường',
          'Check for abnormal growth patterns',
        ),
        BilingualText(
          'Tìm dấu hiệu héo hoặc rủ xuống',
          'Look for signs of wilting or drooping',
        ),
      ],
      causes: [
        BilingualText(
          'Mầm bệnh nấm hoặc vi khuẩn',
          'Fungal or bacterial pathogens',
        ),
        BilingualText(
          'Các yếu tố căng thẳng môi trường',
          'Environmental stress factors',
        ),
        BilingualText(
          'Thực hành canh tác kém',
          'Poor cultural practices',
        ),
        BilingualText(
          'Thiếu các biện pháp phòng ngửa bệnh',
          'Lack of disease prevention',
        ),
      ],
      preventionTips: [
        BilingualText(
          'Thực hiện luân canh (chu kỳ 3-4 năm)',
          'Practice crop rotation (3-4 year cycle)',
        ),
        BilingualText(
          'Sử dụng giống kháng bệnh khi có sẵn',
          'Use disease-resistant varieties when available',
        ),
        BilingualText(
          'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
          'Ensure proper plant spacing for air circulation',
        ),
        BilingualText(
          'Tưới nước ở gốc cây, tránh làm ướt lá',
          'Water at base of plants, avoid wetting foliage',
        ),
        BilingualText(
          'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
          'Remove and destroy infected plant debris',
        ),
        BilingualText(
          'Phủ mulch đễ ngăn đất bắn lên lá',
          'Apply mulch to prevent soil splash onto leaves',
        ),
        BilingualText(
          'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
          'Sterilize gardening tools between uses',
        ),
        BilingualText(
          'Theo dõi cây thường xuyên để phát hiện sớm',
          'Monitor plants regularly for early signs',
        ),
      ],
      organicTreatments: [
        BilingualText(
          'Xịt thuốc diệt nấm gốc đồng',
          'Apply copper-based fungicides',
        ),
        BilingualText(
          'Sử dụng xịt dầu neem hàng tuần',
          'Use neem oil sprays weekly',
        ),
        BilingualText(
          'Dung dịch baking soda (1 thìa canh/gallon nước)',
          'Baking soda solution (1 tbsp per gallon water)',
        ),
        BilingualText(
          'Xịt thuốc diệt nấm gốc lưu huỳnh',
          'Sulfur-based fungicide sprays',
        ),
        BilingualText(
          'Bón vi sinh vật có lợi',
          'Beneficial microorganism applications',
        ),
      ],
      chemicalTreatments: [
        BilingualText(
          'Thuốc diệt nấm chứa chlorothalonil',
          'Fungicides containing chlorothalonil',
        ),
        BilingualText(
          'Sản phẩm gốc mancozeb',
          'Mancozeb-based products',
        ),
        BilingualText(
          'Công thức azoxystrobin',
          'Azoxystrobin formulations',
        ),
        BilingualText(
          'Tuân thủ hướng dẫn trên nhãn cẩn thận',
          'Follow label instructions carefully',
        ),
      ],
      culturalPractices: [
        BilingualText(
          'Loại bỏ lá bị nhiễm ngay lập tức',
          'Remove infected leaves immediately',
        ),
        BilingualText(
          'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
          'Improve soil nutrition with balanced fertilizers',
        ),
        BilingualText(
          'Tỉa cành để lưu thông không khí tốt hơn',
          'Prune for better air circulation',
        ),
        BilingualText(
          'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
          'Stake or cage plants to keep foliage off ground',
        ),
        BilingualText(
          'Tránh làm việc với cây khi ướt',
          'Avoid working with plants when wet',
        ),
      ],
    ),
  };

  // Helper method to normalize label for lookup
  static String _normalizeLabel(String label) {
    final normalized = label
        .toLowerCase()
        .replaceAll('___', ' ')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    
    // Map common patterns to standardized keys
    if (normalized.contains('healthy')) return 'healthy';
    if (normalized.contains('early blight')) return 'early_blight';
    if (normalized.contains('late blight')) return 'late_blight';
    if (normalized.contains('cercospora')) return 'cercospora_leaf_spot';
    if (normalized.contains('septoria')) return 'septoria_leaf_spot';
    if (normalized.contains('bacterial spot')) return 'bacterial_spot';
    if (normalized.contains('leaf mold')) return 'leaf_mold';
    if (normalized.contains('target spot')) return 'target_spot';
    if (normalized.contains('mosaic virus')) return 'mosaic_virus';
    if (normalized.contains('yellow leaf curl')) return 'yellow_leaf_curl';
    if (normalized.contains('scab')) return 'scab';
    if (normalized.contains('black rot')) return 'black_rot';
    if (normalized.contains('rust')) return 'rust';
    if (normalized.contains('esca')) return 'esca';
    if (normalized.contains('isariopsis')) return 'blight';
    if (normalized.contains('blight')) return 'blight';
    
    return normalized;
  }

  // Get disease info by label
  static DiseaseInfo? getInfo(String label) {
    final key = _normalizeLabel(label);
    return _diseaseData[key];
  }

  // Get description
  static String getDescription(String label, String locale) {
    final info = getInfo(label);
    return info?.description.getLocalized(locale) ?? 
           (locale == 'vi' 
               ? 'Thông tin bệnh không có sẵn.' 
               : 'Disease information not available.');
  }

  // Get symptoms
  static List<String> getSymptoms(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Quan sát cây để tìm các đốm bất thường, đổi màu hoặc vết thương',
        'Theo dõi sự thay đổi màu sắc hoặc kết cấu của lá',
        'Kiểm tra các kiểu phát triển bất thường',
        'Tìm dấu hiệu héo hoặc rủ xuống',
      ] : [
        'Observe plants for unusual spots, discoloration, or lesions',
        'Monitor for changes in leaf color or texture',
        'Check for abnormal growth patterns',
        'Look for signs of wilting or drooping',
      ];
    }
    return info.symptoms.map((s) => s.getLocalized(locale)).toList();
  }

  // Get causes
  static List<String> getCauses(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Mầm bệnh nấm hoặc vi khuẩn',
        'Các yếu tố căng thẳng môi trường',
        'Thực hành canh tác kém',
        'Thiếu các biện pháp phòng ngửa bệnh',
      ] : [
        'Fungal or bacterial pathogens',
        'Environmental stress factors',
        'Poor cultural practices',
        'Lack of disease prevention',
      ];
    }
    return info.causes.map((c) => c.getLocalized(locale)).toList();
  }

  // Get prevention tips
  static List<String> getPreventionTips(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Thực hiện luân canh (chu kỳ 3-4 năm)',
        'Sử dụng giống kháng bệnh khi có sẵn',
        'Đảm bảo khoảng cách cây phù hợp để lưu thông không khí',
        'Tưới nước ở gốc cây, tránh làm ướt lá',
        'Loại bỏ và tiêu hủy mảnh vụn cây bị nhiễm',
        'Phủ mulch đễ ngăn đất bắn lên lá',
        'Khử trùng dụng cụ làm vườn giữa các lần sử dụng',
        'Theo dõi cây thường xuyên để phát hiện sớm',
      ] : [
        'Practice crop rotation (3-4 year cycle)',
        'Use disease-resistant varieties when available',
        'Ensure proper plant spacing for air circulation',
        'Water at base of plants, avoid wetting foliage',
        'Remove and destroy infected plant debris',
        'Apply mulch to prevent soil splash onto leaves',
        'Sterilize gardening tools between uses',
        'Monitor plants regularly for early signs',
      ];
    }
    return info.preventionTips.map((p) => p.getLocalized(locale)).toList();
  }

  // Get organic treatments
  static List<String> getOrganicTreatments(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Xịt thuốc diệt nấm gốc đồng',
        'Sử dụng xịt dầu neem hàng tuần',
        'Dung dịch baking soda (1 thìa canh/gallon nước)',
        'Xịt thuốc diệt nấm gốc lưu huỳnh',
        'Bón vi sinh vật có lợi',
      ] : [
        'Apply copper-based fungicides',
        'Use neem oil sprays weekly',
        'Baking soda solution (1 tbsp per gallon water)',
        'Sulfur-based fungicide sprays',
        'Beneficial microorganism applications',
      ];
    }
    return info.organicTreatments.map((t) => t.getLocalized(locale)).toList();
  }

  // Get chemical treatments
  static List<String> getChemicalTreatments(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Thuốc diệt nấm chứa chlorothalonil',
        'Sản phẩm gốc mancozeb',
        'Công thức azoxystrobin',
        'Tuân thủ hướng dẫn trên nhãn cẩn thận',
      ] : [
        'Fungicides containing chlorothalonil',
        'Mancozeb-based products',
        'Azoxystrobin formulations',
        'Follow label instructions carefully',
      ];
    }
    return info.chemicalTreatments.map((t) => t.getLocalized(locale)).toList();
  }

  // Get cultural practices
  static List<String> getCulturalPractices(String label, String locale) {
    final info = getInfo(label);
    if (info == null) {
      return locale == 'vi' ? [
        'Loại bỏ lá bị nhiễm ngay lập tức',
        'Cải thiện dinh dưỡng đất bằng phân bón cân bằng',
        'Tỉa cành để lưu thông không khí tốt hơn',
        'Dựng cọc hoặc lồng để giữ lá khỏi mặt đất',
        'Tránh làm việc với cây khi ướt',
      ] : [
        'Remove infected leaves immediately',
        'Improve soil nutrition with balanced fertilizers',
        'Prune for better air circulation',
        'Stake or cage plants to keep foliage off ground',
        'Avoid working with plants when wet',
      ];
    }
    return info.culturalPractices.map((p) => p.getLocalized(locale)).toList();
  }

  // Get plant name
  static String getPlantName(String label, String locale) {
    final labelPlant = _extractPlantPrefix(label);
    if (labelPlant != null && _plantNameByLabelPrefix.containsKey(labelPlant)) {
      return _plantNameByLabelPrefix[labelPlant]!.getLocalized(locale);
    }

    final info = getInfo(label);
    return info?.plantName.getLocalized(locale) ??
        (locale == 'vi' ? 'Cây không xác định' : 'Unknown Plant');
  }

  // Get disease name
  static String getDiseaseName(String label, String locale) {
    final info = getInfo(label);
    if (info != null) {
      return info.diseaseName.getLocalized(locale);
    }

    final diseasePart = _extractDiseasePart(label);
    if (diseasePart.isNotEmpty) {
      final normalized = diseasePart.toLowerCase();
      if (normalized.contains('healthy')) {
        return locale == 'vi' ? 'Khỏe mạnh' : 'Healthy';
      }
      return _titleCaseWords(diseasePart);
    }

    return locale == 'vi' ? 'Bệnh không xác định' : 'Unknown Disease';
  }

  static String? _extractPlantPrefix(String label) {
    final normalized = label.trim();
    if (normalized.isEmpty) return null;

    if (normalized.contains('___')) {
      final prefix = normalized.split('___').first.trim().toLowerCase();
      return prefix.isEmpty ? null : prefix;
    }

    final tokens = normalized.split(RegExp(r'\s+'));
    if (tokens.isEmpty) return null;
    final candidate = tokens.first.trim().toLowerCase();
    return candidate.isEmpty ? null : candidate;
  }

  static String _extractDiseasePart(String label) {
    final normalized = label.trim();
    if (normalized.isEmpty) return '';

    String diseasePart;
    if (normalized.contains('___')) {
      final parts = normalized.split('___');
      diseasePart = parts.length > 1 ? parts.sublist(1).join('___') : '';
    } else {
      final tokens = normalized.split(RegExp(r'\s+'));
      diseasePart = tokens.length > 1 ? tokens.sublist(1).join(' ') : normalized;
    }

    return diseasePart
        .replaceAll('_', ' ')
        .replaceAll('(', ' (')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _titleCaseWords(String input) {
    if (input.isEmpty) return input;

    final lower = input.toLowerCase();
    final words = lower.split(' ');
    final transformed = words.map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
    return transformed.trim();
  }
}

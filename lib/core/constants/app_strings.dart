/// App Strings - Tiếng Việt
class AppStrings {
  AppStrings._();

  // Chung
  static const String about = 'Giới thiệu';
  static const String home = 'Trang chủ';
  static const String history = 'Lịch sử';
  static const String info = 'Thông tin';
  static const String loading = 'Đang tải...';
  static const String error = 'Lỗi';
  static const String cancel = 'Hủy';
  static const String delete = 'Xóa';
  static const String clear = 'Xóa';
  static const String confidence = 'Độ tin cậy';
  static const String status = 'Trạng thái';
  static const String healthy = 'Khỏe mạnh';
  static const String diseased = 'Bị bệnh';
  static const String version = 'Phiên bản';
  static const String released = 'Phát hành';
  
  // Trang chủ
  static const String aiPlantScanner = 'Máy Quét Cây AI';
  static const String scanAnyPlantLeaf = 'Quét bất kỳ lá cây nào';
  static const String aiIdentifyDescription = 'AI sẽ nhận dạng loại cây và phát hiện các dấu hiệu bệnh trong vài giây';
  static const String takePicture = 'Chụp ảnh';
  static const String selectFromGallery = 'Chọn từ thư viện';
  static const String retake = 'Chụp lại';
  static const String useThisImage = 'Sử dụng ảnh này';
  static const String noImageSelected = 'Chưa chọn ảnh';
  static const String selectImage = 'Chọn ảnh';
  static const String imageCaptured = 'Đã chụp ảnh';
  static const String imageSelected = 'Đã chọn ảnh';
  static const String captureError = 'Lỗi chụp ảnh';
  
  // Tính năng chính
  static const String keyFeatures = 'Tính năng chính';
  static const String autoPlantRecognition = 'Nhận dạng cây tự động';
  static const String autoPlantRecognitionDesc = 'Tự động xác định loại cây trồng từ ảnh lá';
  static const String multiDiseaseClassification = 'Phân loại đa bệnh';
  static const String multiDiseaseClassificationDesc = 'Phát hiện nhiều loại bệnh cây trồng khác nhau';
  static const String instantResults = 'Kết quả tức thì';
  static const String instantResultsDesc = 'Nhận chẩn đoán AI trong vài giây';
  static const String offlineMode = 'Chế độ ngoại tuyến';
  static const String offlineModeDesc = 'Hoạt động hoàn toàn offline, không cần internet';
  
  // Cây trồng được hỗ trợ
  static const String supportedPlants = 'Cây được hỗ trợ';
  static const String supportedCrops = 'Cây trồng được hỗ trợ';
  static const String currentlySupported = 'Hiện đang hỗ trợ';
  static const String cropsAvailable = 'cây trồng có sẵn';
  static const String multiCropDetection = 'Phát hiện đa cây trồng';
  static const String multiCropDetectionDesc = 'Hệ thống AI của chúng tôi có thể nhận dạng và chẩn đoán bệnh trên nhiều loại cây trồng';
  static const String comingSoon = 'Sắp ra mắt';
  static const String soon = 'Sớm';
  static const String moreCropsWillBeAdded = 'Thêm nhiều cây trồng sẽ được thêm vào trong các bản cập nhật tương lai';
  static const String viewDetails = 'Xem chi tiết';
  static const String diseasesCount = 'bệnh';
  
  // Tên cây trồng
  static const String tomato = 'Cà chua';
  static const String grape = 'Nho';
  static const String potato = 'Khoai tây';
  static const String apple = 'Táo';
  static const String corn = 'Ngô';
  static const String rice = 'Lúa';
  static const String bellPepper = 'Ớt chuông';
  static const String cucumber = 'Dưa chuột';
  static const String soybean = 'Đậu nành';
  static const String chili = 'Ớt';
  static const String moreText = 'Thêm...';
  
  // Lịch sử
  static const String scanHistory = 'Lịch sử quét';
  static const String totalScans = 'lần quét';
  static const String noScanHistoryYet = 'Chưa có lịch sử quét';
  static const String startScanningToSeeResults = 'Bắt đầu quét để xem kết quả';
  static const String clearHistory = 'Xóa lịch sử';
  static const String clearHistoryConfirm = 'Bạn có chắc muốn xóa toàn bộ lịch sử?';
  static const String deleteItem = 'Xóa mục';
  static const String deleteItemConfirm = 'Bạn có chắc muốn xóa mục này?';
  static const String itemDeleted = 'Đã xóa mục';
  static const String scanDetail = 'Chi tiết quét';
  static const String notes = 'Ghi chú';
  static const String notesPlaceholder = 'Thêm ghi chú của bạn...';
  
  // Kết quả phân tích
  static const String analysisComplete = 'Phân tích hoàn tất';
  static const String analysisError = 'Lỗi phân tích';
  static const String aiIdentifiedPlant = 'AI đã nhận dạng cây trồng';
  static const String plantIdentification = 'Nhận dạng cây trồng';
  static const String detectedPlant = 'Cây phát hiện';
  static const String confidenceScore = 'Điểm tin cậy';
  static const String diseaseDetection = 'Phát hiện bệnh';
  static const String diseaseName = 'Tên bệnh';
  static const String modelConfidence = 'Độ tin cậy mô hình';
  static const String quickSummary = 'Tóm tắt nhanh';
  static const String mainSymptoms = 'Triệu chứng chính';
  static const String viewDetailedInformation = 'Xem thông tin chi tiết';
  static const String scanAnother = 'Quét ảnh khác';
  static const String disclaimer = 'Lưu ý: Đây là kết quả chẩn đoán tự động. Vui lòng tham khảo ý kiến chuyên gia nông nghiệp để có phương án điều trị chính xác.';
  
  // Chi tiết bệnh
  static const String diseaseDetails = 'Chi tiết bệnh';
  static const String diseasesDetected = 'Bệnh phát hiện';
  static const String diseasesList = 'Danh sách bệnh';
  static const String identifiedDisease = 'Bệnh đã xác định';
  static const String symptoms = 'Triệu chứng';
  static const String causes = 'Nguyên nhân';
  static const String prevention = 'Phòng ngừa';
  static const String preventionTips = 'Mẹo phòng ngừa';
  static const String possibleCauses = 'Nguyên nhân có thể';
  static const String organicTreatment = 'Điều trị hữu cơ';
  static const String organicOptions = 'Phương pháp hữu cơ';
  static const String chemicalTreatment = 'Điều trị hóa học';
  static const String chemicalOptions = 'Phương pháp hóa học';
  static const String culturalPractices = 'Thực hành canh tác';
  static const String maintenanceTips = 'Mẹo bảo dưỡng';
  static const String basicTreatmentSuggestions = 'Đề xuất điều trị cơ bản';
  static const String importantDisclaimer = 'Thông báo quan trọng';
  static const String importantDisclaimerDesc = 'Đây là hướng dẫn tổng quát. Vui lòng tham khảo ý kiến chuyên gia nông nghiệp địa phương để có phương án điều trị phù hợp với điều kiện cụ thể.';
  
  // Xác thực ảnh
  static const String poorImageQuality = 'Chất lượng ảnh kém';
  static const String poorImageQualityDesc = 'Ảnh quá mờ hoặc tối. Vui lòng chụp ảnh rõ nét hơn trong điều kiện ánh sáng tốt.';
  static const String lowConfidence = 'Độ tin cậy thấp';
  static const String lowConfidenceDesc = 'AI không chắc chắn về kết quả. Vui lòng thử ảnh khác với góc chụp rõ ràng hơn.';
  static const String imageOutOfScope = 'Ảnh ngoài phạm vi';
  static const String imageOutOfScopeDesc = 'Ảnh không chứa lá cây được hỗ trợ hoặc không phù hợp với mô hình.';
  static const String verificationFailed = 'Xác thực thất bại';
  static const String errorOccurred = 'Đã xảy ra lỗi';
  static const String imageQualityScore = 'Điểm chất lượng ảnh';
  static const String retryWithBetterImage = 'Thử lại với ảnh tốt hơn';
  
  // Thông tin AI
  static const String aiAndSmartAgriculture = 'AI và Nông nghiệp Thông minh';
  static const String ourMission = 'Sứ mệnh của chúng tôi';
  static const String ourMissionDesc = 'Giúp nông dân và người trồng cây phát hiện bệnh cây sớm bằng công nghệ AI, giảm thiệt hại mùa màng và tăng năng suất.';
  static const String howAiWorks = 'AI hoạt động như thế nào';
  static const String howAiWorksDesc = 'Ứng dụng của chúng tôi sử dụng Deep Learning và Computer Vision để phân tích ảnh lá cây và phát hiện các dấu hiệu bệnh.';
  
  // Công nghệ
  static const String convolutionalNeuralNetworks = 'Mạng Nơ-ron Tích chập (CNN)';
  static const String convolutionalNeuralNetworksDesc = 'Kiến trúc mạng nơ-ron chuyên dụng cho xử lý và phân tích ảnh';
  static const String computerVision = 'Computer Vision';
  static const String computerVisionDesc = 'Công nghệ cho phép máy tính "nhìn" và hiểu nội dung hình ảnh';
  static const String deepLearningTraining = 'Đào tạo Deep Learning';
  static const String deepLearningTrainingDesc = 'Mô hình được huấn luyện trên hàng ngàn ảnh lá cây để nhận dạng các mẫu bệnh';
  static const String cnnAndDeepLearning = 'CNN & Deep Learning';
  static const String cnnAndDeepLearningDesc = 'Ứng dụng sử dụng mô hình CNN được đào tạo trên hàng ngàn hình ảnh để nhận dạng các mẫu bệnh trong lá cây với độ chính xác cao.';
  
  // Tính năng kỹ thuật
  static const String technicalFeatures = 'Tính năng kỹ thuật';
  static const String cnnArchitecture = 'Kiến trúc CNN';
  static const String cnnArchitectureDesc = 'Mô hình deep learning hiện đại';
  static const String multiCropSupport = 'Hỗ trợ nhiều cây trồng';
  static const String multiCropSupportDesc = '5+ loại cây được hỗ trợ';
  static const String highAccuracy = 'Độ chính xác cao';
  static const String highAccuracyDesc = '~97% độ chính xác phát hiện';
  static const String realTimeProcessing = 'Xử lý thời gian thực';
  static const String realTimeProcessingDesc = 'Kết quả tức thì trên thiết bị';
  
  // Hiệu suất mô hình
  static const String modelPerformance = 'Hiệu suất mô hình';
  static const String accuracy = 'Độ chính xác';
  static const String trainingDataset = 'Dữ liệu huấn luyện';
  static const String diseaseClasses = 'Lớp bệnh';
  static const String images = 'ảnh';
  static const String types = 'loại';
  
  // Lợi ích
  static const String benefitsOfAi = 'Lợi ích của AI';
  static const String earlyDetection = 'Phát hiện sớm';
  static const String earlyDetectionDesc = 'Phát hiện bệnh ở giai đoạn đầu để điều trị hiệu quả';
  static const String costEffective = 'Tiết kiệm chi phí';
  static const String costEffectiveDesc = 'Giảm chi phí bằng cách ngăn ngừa thiệt hại lớn về mùa màng';
  static const String ecoFriendly = 'Thân thiện môi trường';
  static const String ecoFriendlyDesc = 'Giảm sử dụng thuốc trừ sâu không cần thiết';
  static const String dataPrivacy = 'Bảo mật dữ liệu';
  static const String dataPrivacyDesc = 'Tất cả xử lý diễn ra trên thiết bị, không dữ liệu được gửi đi';
  static const String dataDriven = 'Dựa trên dữ liệu';
  static const String dataDrivenDesc = 'Quyết định dựa trên phân tích khoa học và dữ liệu';
  
  // Đối tượng sử dụng
  static const String whoCanUseOurApp = 'Ai có thể sử dụng ứng dụng?';
  static const String farmersAndGrowers = 'Nông dân và Người trồng';
  static const String farmersAndGrowersDesc = 'Phát hiện và quản lý bệnh cây trồng nhanh chóng';
  static const String studentsAndResearchers = 'Sinh viên và Nghiên cứu viên';
  static const String studentsAndResearchersDesc = 'Tìm hiểu về bệnh cây trồng và công nghệ AI';
  static const String homeGardeners = 'Người làm vườn';
  static const String homeGardenersDesc = 'Giữ cho vườn nhà bạn khỏe mạnh và không bệnh tật';
  
  // Hỗ trợ
  static const String supportInformation = 'Thông tin hỗ trợ';
  static const String supportInformationDesc = 'Để được hỗ trợ kỹ thuật hoặc báo cáo vấn đề, vui lòng liên hệ qua email hoặc GitHub repository.';
  
  // Nền tảng học thuật
  static const String academicFoundation = 'Nền tảng học thuật';
  static const String academicFoundationDesc = 'Dự án này được phát triển như một phần của nghiên cứu học thuật về ứng dụng Deep Learning trong nông nghiệp thông minh.';
  
  // Công nghệ sử dụng
  static const String technologies = 'Công nghệ';
  static const String deepLearning = 'Deep Learning';
  static const String imageAnalysis = 'Phân tích ảnh';
  static const String mobileUI = 'Mobile UI';
  static const String modelTraining = 'Đào tạo mô hình';
  static const String developedFor = 'Phát triển cho mục đích nghiên cứu và giáo dục';
}

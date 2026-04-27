// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Phát hiện bệnh cây trồng';

  @override
  String get home => 'Trang chủ';

  @override
  String get history => 'Lịch sử';

  @override
  String get info => 'Thông tin';

  @override
  String get supportedPlants => 'Cây được hỗ trợ';

  @override
  String get aiPlantScanner => 'Quét cây AI';

  @override
  String get scanAnyPlantLeaf => 'Quét lá cây bất kỳ';

  @override
  String get aiIdentifyDescription =>
      'AI sẽ nhận diện loại cây và phát hiện bệnh\ntự động';

  @override
  String get takePicture => 'Chụp ảnh';

  @override
  String get selectFromGallery => 'Chọn từ thư viện';

  @override
  String get selectImage => 'Chọn ảnh';

  @override
  String get analyzing => 'Đang phân tích...';

  @override
  String get pleaseWait => 'Vui lòng đợi';

  @override
  String get detectionResult => 'Kết quả phát hiện';

  @override
  String get confidence => 'Độ tin cậy';

  @override
  String get viewDetails => 'Xem chi tiết';

  @override
  String get retake => 'Chụp lại';

  @override
  String get useThisImage => 'Dùng ảnh';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get diseaseInformation => 'Thông tin bệnh';

  @override
  String get symptoms => 'Triệu chứng';

  @override
  String get causes => 'Nguyên nhân';

  @override
  String get prevention => 'Phòng ngừa';

  @override
  String get treatment => 'Điều trị';

  @override
  String get diseasesDetected => 'Bệnh được phát hiện';

  @override
  String get diseasesList => 'Danh sách bệnh';

  @override
  String get diseasesCount => 'bệnh';

  @override
  String get organicTreatment => 'Điều trị hữu cơ';

  @override
  String get chemicalTreatment => 'Điều trị hóa học';

  @override
  String get culturalPractices => 'Thực hành canh tác:';

  @override
  String get maintenanceTips => 'Lời khuyên chăm sóc';

  @override
  String get historyTitle => 'Lịch sử phát hiện';

  @override
  String get noHistory => 'Chưa có lịch sử phát hiện';

  @override
  String get deleteHistory => 'Xóa lịch sử';

  @override
  String get clearAll => 'Xóa tất cả';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteConfirm => 'Bạn có chắc chắn muốn xóa mục này?';

  @override
  String get deleteAllConfirm => 'Bạn có chắc chắn muốn xóa toàn bộ lịch sử?';

  @override
  String get deleteItem => 'Xóa mục';

  @override
  String get deleteItemConfirm =>
      'Bạn có chắc chắn muốn xóa mục này khỏi lịch sử?';

  @override
  String get itemDeleted => 'Mục đã được xóa';

  @override
  String get scanDetail => 'Chi tiết quét';

  @override
  String get status => 'Trạng thái';

  @override
  String get healthy => 'Khỏe mạnh';

  @override
  String get diseased => 'Bị bệnh';

  @override
  String get notes => 'Ghi chú';

  @override
  String get notesPlaceholder =>
      'Thêm ghi chú của chuyên gia nông nghiệp, phương pháp điều trị đã áp dụng hoặc bối cảnh môi trường tại đây.';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get changeLanguage => 'Đổi ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get aboutApp => 'Về ứng dụng';

  @override
  String get version => 'Phiên bản';

  @override
  String get developer => 'Nhà phát triển';

  @override
  String get error => 'Lỗi';

  @override
  String get errorOccurred => 'Đã xảy ra lỗi';

  @override
  String get tryAgain => 'Thử lại';

  @override
  String get loading => 'Đang tải...';

  @override
  String get imageSelected => '✓ Ảnh đã được chọn';

  @override
  String get imageNotFound => 'Không tìm thấy ảnh';

  @override
  String get processingImage => 'Đang xử lý ảnh...';

  @override
  String get plantName => 'Tên cây';

  @override
  String get diseaseName => 'Tên bệnh';

  @override
  String get detectedOn => 'Phát hiện lúc';

  @override
  String get learnMore => 'Tìm hiểu thêm';

  @override
  String get back => 'Quay lại';

  @override
  String get close => 'Đóng';

  @override
  String get noImageSelected => 'Chưa chọn ảnh';

  @override
  String get selectImageFirst => 'Vui lòng chọn ảnh trước';

  @override
  String get cameraPermissionRequired => 'Cần quyền truy cập camera';

  @override
  String get storagePermissionRequired => 'Cần quyền truy cập bộ nhớ';

  @override
  String get permissionDenied => 'Quyền truy cập bị từ chối';

  @override
  String get savingImage => 'Đang lưu ảnh...';

  @override
  String get imageSaved => 'Đã lưu ảnh';

  @override
  String get imageCaptured => '✓ Ảnh đã được chụp';

  @override
  String get captureError => '❌ Lỗi chụp ảnh';

  @override
  String get cameraNotFoundOnDevice => 'Không tìm thấy camera trên thiết bị';

  @override
  String cameraInitializationError(Object error) {
    return 'Lỗi khởi tạo camera: $error';
  }

  @override
  String get cameraInitializing => 'Đang khởi tạo camera...';

  @override
  String get cameraCaptureLeafTitle => 'Chụp ảnh lá cây';

  @override
  String get cameraTipsTitle => 'Mẹo chụp ảnh chính xác:';

  @override
  String get cameraTipsBody =>
      '• Đặt lá trong khung trắng\n• Ánh sáng đủ, không mờ\n• Lá phẳng, rõ nét\n• Tránh bóng đổ';

  @override
  String get cameraAccessDenied =>
      'Quyền truy cập camera/thư viện bị từ chối. Vui lòng bật quyền trong cài đặt.';

  @override
  String get cameraDeviceError => 'Lỗi camera. Vui lòng kiểm tra thiết bị.';

  @override
  String get insufficientMemory =>
      'Bộ nhớ không đủ. Vui lòng dọn dẹp thiết bị.';

  @override
  String get processingFailed => 'Xử lý thất bại';

  @override
  String get modelLoadFailed => 'Không thể tải mô hình';

  @override
  String get analysisError => 'Phân tích thất bại';

  @override
  String get detectionAccuracy => 'Độ chính xác';

  @override
  String get verificationFailed => 'Xác thực thất bại';

  @override
  String get imageOutOfScope => 'Không thuộc danh mục hỗ trợ';

  @override
  String get imageOutOfScopeDesc =>
      'Ảnh này không thuộc bất kỳ loại cây nào được hỗ trợ. Vui lòng chụp ảnh lá cà chua, khoai tây, nho, táo hoặc ngô.';

  @override
  String get lowConfidence => 'Không đủ độ tin cậy';

  @override
  String get lowConfidenceDesc =>
      'Mô hình AI chưa đủ tin cậy về dự đoán này. Vui lòng thử:\n• Chụp ảnh rõ nét hơn\n• Ánh sáng tốt hơn\n• Gần lá cây hơn';

  @override
  String get poorImageQuality => 'Ảnh không đạt chất lượng';

  @override
  String get poorImageQualityDesc =>
      'Ảnh quá mờ hoặc không rõ ràng. Vui lòng:\n• Giữ camera ổn định\n• Đảm bảo ánh sáng đầy đủ\n• Lấy nét vào lá cây';

  @override
  String get imageQualityScore => 'Chất lượng ảnh';

  @override
  String get retryWithBetterImage => 'Thử lại với ảnh tốt hơn';

  @override
  String get highConfidence => 'Độ tin cậy cao';

  @override
  String get mediumConfidence => 'Độ tin cậy trung bình';

  @override
  String get keyFeatures => 'Tính năng chính';

  @override
  String get autoPlantRecognition => 'Nhận diện cây tự động';

  @override
  String get autoPlantRecognitionDesc => 'AI tự động xác định loài cây';

  @override
  String get multiDiseaseClassification => 'Phân loại đa bệnh';

  @override
  String get multiDiseaseClassificationDesc => 'Phát hiện nhiều loại bệnh cây';

  @override
  String get instantResults => 'Kết quả tức thì';

  @override
  String get instantResultsDesc => 'Phân tích nhanh chỉ trong vài giây';

  @override
  String get offlineMode => 'Chế độ offline';

  @override
  String get offlineModeDesc => 'Hoạt động không cần internet';

  @override
  String get supportedCrops => 'Cây trồng được hỗ trợ';

  @override
  String get cropVarieties => 'loại cây';

  @override
  String get diseases => 'bệnh';

  @override
  String get aiPowered => 'Hỗ trợ bởi AI';

  @override
  String get aiWillIdentify =>
      'AI sẽ tự động nhận diện cây trồng\nvà phát hiện bệnh';

  @override
  String get uploadImage => 'Tải ảnh lên';

  @override
  String get about => 'Giới thiệu';

  @override
  String get currentlySupported => 'Đang hỗ trợ';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get tomato => 'Cà chua';

  @override
  String get grape => 'Nho';

  @override
  String get potato => 'Khoai tây';

  @override
  String get apple => 'Táo';

  @override
  String get corn => 'Ngô';

  @override
  String get rice => 'Lúa';

  @override
  String get bellPepper => 'Ớt chuông';

  @override
  String get strawberry => 'Dâu tây';

  @override
  String get soybean => 'Đậu nành';

  @override
  String get cucumber => 'Dưa chuột';

  @override
  String get chili => 'Ờt';

  @override
  String get moreText => 'thêm';

  @override
  String get multiCropDetection => 'Phát hiện đa loại cây';

  @override
  String get multiCropDetectionDesc =>
      'AI của chúng tôi tự động nhận diện loài cây và phát hiện bệnh đặc trưng cho từng loại cây';

  @override
  String get cropsAvailable => 'cây có sẵn';

  @override
  String get scanHistory => 'Lịch sử quét';

  @override
  String get totalScans => 'lần quét';

  @override
  String get clearHistory => 'Xóa lịch sử';

  @override
  String get clearHistoryConfirm =>
      'Bạn có chắc chắn muốn xóa toàn bộ lịch sử quét?';

  @override
  String get noScanHistoryYet => 'Chưa có lịch sử quét';

  @override
  String get startScanningToSeeResults => 'Bắt đầu quét để xem kết quả tại đây';

  @override
  String get clear => 'Xóa';

  @override
  String get ourMission => 'Sứ mệnh của chúng tôi';

  @override
  String get ourMissionDesc =>
      'Trao quyền cho nông dân với công nghệ AI dễ tiếp cận để phát hiện bệnh sớm';

  @override
  String get howAiWorks => 'AI hoạt động như thế nào trong nông nghiệp';

  @override
  String get howAiWorksDesc =>
      'Hệ thống AI của chúng tôi được thiết kế để giám sát sức khỏe cây trồng một cách dễ tiếp cận và chính xác cho mọi người';

  @override
  String get convolutionalNeuralNetworks => 'Mạng nơ-ron tích chập';

  @override
  String get convolutionalNeuralNetworksDesc =>
      'Kiến trúc học sâu tiên tiến mô phỏng thị giác con người để phân tích các mẫu lá cây';

  @override
  String get computerVision => 'Thị giác máy tính';

  @override
  String get computerVisionDesc =>
      'Phân tích các mẫu hình ảnh như đốm, đổi màu và kết cấu để xác định bệnh cụ thể';

  @override
  String get deepLearningTraining => 'Đào tạo học sâu';

  @override
  String get deepLearningTrainingDesc =>
      'Mô hình của chúng tôi được đào tạo trên hàng nghìn ảnh cây có gán nhãn để liên tục cải thiện độ chính xác';

  @override
  String get technicalFeatures => 'Tính năng kỹ thuật';

  @override
  String get cnnArchitecture => 'Mạng nơ-ron tích chập (CNN)';

  @override
  String get cnnArchitectureDesc => 'Kiến trúc nhận dạng hình ảnh tiên tiến';

  @override
  String get multiCropSupport => 'Hỗ trợ đa loại cây';

  @override
  String get multiCropSupportDesc => 'Hoạt động với nhiều loại cây trồng';

  @override
  String get highAccuracy => 'Độ chính xác cao';

  @override
  String get highAccuracyDesc => 'Được đào tạo trên bộ dữ liệu bệnh phong phú';

  @override
  String get realTimeProcessing => 'Xử lý thời gian thực';

  @override
  String get realTimeProcessingDesc => 'Suy luận trên thiết bị không có độ trễ';

  @override
  String get benefitsOfAi => 'Lợi ích của AI trong nông nghiệp';

  @override
  String get earlyDetection => 'Phát hiện sớm';

  @override
  String get earlyDetectionDesc =>
      'Phát hiện bệnh trước khi triệu chứng xuất hiện';

  @override
  String get costEffective => 'Tiết kiệm chi phí';

  @override
  String get costEffectiveDesc =>
      'Giảm thiệt hại mùa màng và tối ưu hóa điều trị';

  @override
  String get ecoFriendly => 'Thân thiện môi trường';

  @override
  String get ecoFriendlyDesc =>
      'Giảm thiểu sử dụng thuốc trừ sâu với canh tác chính xác';

  @override
  String get dataPrivacy => 'Quyền riêng tư dữ liệu';

  @override
  String get dataPrivacyDesc =>
      'Tất cả xử lý diễn ra cục bộ trên thiết bị của bạn';

  @override
  String get analysisComplete => 'Phân tích hoàn tất';

  @override
  String get aiIdentifiedPlant => 'AI đã nhận diện cây và phát hiện bệnh';

  @override
  String get plantIdentification => 'Nhận diện cây trồng';

  @override
  String get detectedPlant => 'Cây được phát hiện';

  @override
  String get confidenceScore => 'Điểm tin cậy';

  @override
  String get diseaseDetection => 'Phát hiện bệnh';

  @override
  String get modelConfidence => 'Độ tin cậy mô hình';

  @override
  String get quickSummary => 'Tóm tắt nhanh';

  @override
  String get mainSymptoms => 'Triệu chứng chính:';

  @override
  String get viewDetailedInformation => 'Xem thông tin chi tiết';

  @override
  String get scanAnother => 'Quét cây khác';

  @override
  String get saveToHistory => 'Lưu vào lịch sử';

  @override
  String get diseaseDetails => 'Chi tiết bệnh';

  @override
  String get overview => 'Tổng quan';

  @override
  String get identifiedDisease => 'Bệnh được xác định';

  @override
  String get affectedPlant => 'Cây bị ảnh hưởng';

  @override
  String get severityLevel => 'Mức độ nghiêm trọng';

  @override
  String get detectionConfidence => 'Độ tin cậy phát hiện';

  @override
  String get recommendedActions => 'Hành động được đề xuất';

  @override
  String get urgentAction => 'Cần hành động khẩn cấp';

  @override
  String get moderateAction => 'Cần hành động vừa phải';

  @override
  String get lowRisk => 'Rủi ro thấp - Theo dõi';

  @override
  String get severe => 'Nghiêm trọng';

  @override
  String get moderate => 'Trung bình';

  @override
  String get mild => 'Nhẹ';

  @override
  String get backToResults => 'Quay lại kết quả';

  @override
  String get disclaimer =>
      'Lưu ý: Kết quả từ AI. Vui lòng tham khảo ý kiến chuyên gia nông nghiệp để xác nhận và điều trị.';

  @override
  String get detectedDisease => 'Bệnh được phát hiện';

  @override
  String get possibleCauses => 'Nguyên nhân có thể';

  @override
  String get preventionTips => 'Mẹo phòng ngừa';

  @override
  String get basicTreatmentSuggestions => 'Gợi ý điều trị cơ bản';

  @override
  String get organicOptions => 'Phương pháp hữu cơ:';

  @override
  String get chemicalOptions => 'Phương pháp hóa học:';

  @override
  String get dataDriven => 'Dữ liệu định hướng';

  @override
  String get dataDrivenDesc =>
      'Đưa ra quyết định sáng suốt dựa trên thông tin chi tiết từ AI';

  @override
  String get whoCanUseOurApp => 'Ai có thể sử dụng ứng dụng của chúng tôi?';

  @override
  String get farmersAndGrowers => 'Nông dân & Người trồng trọt';

  @override
  String get farmersAndGrowersDesc =>
      'Theo dõi sức khỏe cây trồng và ngăn ngừa thiệt hại';

  @override
  String get studentsAndResearchers => 'Sinh viên & Nhà nghiên cứu';

  @override
  String get studentsAndResearchersDesc => 'Nghiên cứu bệnh cây và ứng dụng AI';

  @override
  String get homeGardeners => 'Người làm vườn tại nhà';

  @override
  String get homeGardenersDesc => 'Giữ cây vườn nhà của bạn khỏe mạnh';

  @override
  String get supportInformation => 'Thông tin hỗ trợ';

  @override
  String get supportInformationDesc =>
      'Ứng dụng này đang được cải thiện liên tục. Chúng tôi đang tích cực mở rộng cơ sở dữ liệu để hỗ trợ thêm nhiều loại cây và bệnh.';

  @override
  String get aiAndSmartAgriculture => 'AI & Nông nghiệp thông minh';

  @override
  String get moreCropsWillBeAdded =>
      'Sẽ có thêm nhiều loại cây khi AI của chúng tôi tiếp tục học hỏi và cải thiện';

  @override
  String get soon => 'Sớm';

  @override
  String get cnnAndDeepLearning => 'CNN & Học sâu';

  @override
  String get cnnAndDeepLearningDesc =>
      'Ứng dụng này sử dụng Mạng nơ-ron tích chập (CNN) được huấn luyện trên hàng nghìn hình ảnh lá cà chua để phân loại bệnh với độ chính xác cao.';

  @override
  String get modelPerformance => 'Hiệu suất mô hình';

  @override
  String get accuracy => 'Độ chính xác';

  @override
  String get trainingDataset => 'Tập dữ liệu huấn luyện';

  @override
  String get diseaseClasses => 'Các loại bệnh';

  @override
  String get images => 'hình ảnh';

  @override
  String get types => 'loại';

  @override
  String get academicFoundation => 'Nền tảng học thuật';

  @override
  String get academicFoundationDesc =>
      'Dựa trên nghiên cứu về thị giác máy tính và nông nghiệp thông minh, kết hợp học sâu với nhu cầu canh tác thực tế.';

  @override
  String get technologies => 'Công nghệ';

  @override
  String get deepLearning => 'Học sâu';

  @override
  String get imageAnalysis => 'Phân tích hình ảnh';

  @override
  String get mobileUI => 'Giao diện di động';

  @override
  String get modelTraining => 'Huấn luyện mô hình';

  @override
  String get released => 'Phát hành';

  @override
  String get developedFor =>
      'Phát triển cho nghiên cứu học thuật và tiến bộ công nghệ nông nghiệp';

  @override
  String get photoQualityAssessment => 'Đánh giá chất lượng ảnh';

  @override
  String get photoQualityAssessmentPassedMessage =>
      'Ảnh đã được kiểm tra chất lượng và phân tích thành công.';

  @override
  String get verificationCaptureTip =>
      'Gợi ý: chụp đủ sáng, giữ máy chắc tay, lấy nét lá bệnh và nền đơn giản.';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get importantDisclaimer => 'Lưu ý quan trọng';

  @override
  String get importantDisclaimerDesc =>
      'Đây là kết quả được tạo bởi AI dựa trên phân tích thị giác máy tính. Để chẩn đoán chính xác và khuyến nghị điều trị, vui lòng tham khảo ý kiến các chuyên gia nông nghiệp, cán bộ khuyến nông hoặc chuyên gia bệnh thực vật được chứng nhận trong khu vực của bạn.';
}

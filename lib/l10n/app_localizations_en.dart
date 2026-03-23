// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Plant Disease Detection';

  @override
  String get home => 'Home';

  @override
  String get history => 'History';

  @override
  String get info => 'Info';

  @override
  String get account => 'Account';

  @override
  String get supportedPlants => 'Supported Plants';

  @override
  String get aiPlantScanner => 'AI Plant Scanner';

  @override
  String get scanAnyPlantLeaf => 'Scan Any Plant Leaf';

  @override
  String get aiIdentifyDescription =>
      'AI will identify the crop and detect diseases\nautomatically';

  @override
  String get takePicture => 'Take Picture';

  @override
  String get selectFromGallery => 'Select from Gallery';

  @override
  String get selectImage => 'Select Image';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get pleaseWait => 'Please wait';

  @override
  String get detectionResult => 'Detection Result';

  @override
  String get confidence => 'Confidence';

  @override
  String get viewDetails => 'View Details';

  @override
  String get retake => 'Retake';

  @override
  String get useThisImage => 'Use This Image';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get diseaseInformation => 'Disease Information';

  @override
  String get symptoms => 'Symptoms';

  @override
  String get causes => 'Causes';

  @override
  String get prevention => 'Prevention';

  @override
  String get treatment => 'Treatment';

  @override
  String get diseasesDetected => 'Diseases Detected';

  @override
  String get diseasesList => 'Diseases List';

  @override
  String get diseasesCount => 'diseases';

  @override
  String get organicTreatment => 'Organic Treatment';

  @override
  String get chemicalTreatment => 'Chemical Treatment';

  @override
  String get culturalPractices => 'Cultural Practices:';

  @override
  String get maintenanceTips => 'Maintenance Tips';

  @override
  String get historyTitle => 'Detection History';

  @override
  String get noHistory => 'No detection history';

  @override
  String get deleteHistory => 'Delete History';

  @override
  String get clearAll => 'Clear All';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirm => 'Are you sure you want to delete this item?';

  @override
  String get deleteAllConfirm => 'Are you sure you want to delete all history?';

  @override
  String get deleteItem => 'Delete Item';

  @override
  String get deleteItemConfirm =>
      'Are you sure you want to delete this item from history?';

  @override
  String get itemDeleted => 'Item deleted';

  @override
  String get scanDetail => 'Scan Detail';

  @override
  String get status => 'Status';

  @override
  String get healthy => 'Healthy';

  @override
  String get diseased => 'Diseased';

  @override
  String get notes => 'Notes';

  @override
  String get notesPlaceholder =>
      'Add your agronomist notes, treatment applied, or environmental context here.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get english => 'English';

  @override
  String get loginToContinue => 'Sign in to continue using the app';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get continueWithoutLogin => 'Continue without login';

  @override
  String get loginCancelled =>
      'You cancelled sign-in. You can continue without login.';

  @override
  String get loginFailed => 'Sign-in failed';

  @override
  String get notLoggedInTitle => 'You are not signed in';

  @override
  String get signInToViewAccount =>
      'Sign in with Google to view your account information.';

  @override
  String get accountLoadFailed => 'Unable to load account information.';

  @override
  String get accountInfoTitle => 'Account Information';

  @override
  String get nameLabel => 'Name';

  @override
  String get emailLabel => 'Email';

  @override
  String get noDisplayName => 'No display name';

  @override
  String get noEmail => 'No email';

  @override
  String get logout => 'Logout';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get logoutFailed => 'Logout failed';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get error => 'Error';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get loading => 'Loading...';

  @override
  String get imageSelected => '✓ Image selected';

  @override
  String get imageNotFound => 'Image not found';

  @override
  String get processingImage => 'Processing image...';

  @override
  String get plantName => 'Plant Name';

  @override
  String get diseaseName => 'Disease Name';

  @override
  String get detectedOn => 'Detected on';

  @override
  String get learnMore => 'Learn More';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get noImageSelected => 'No image selected';

  @override
  String get selectImageFirst => 'Please select an image first';

  @override
  String get cameraPermissionRequired => 'Camera permission required';

  @override
  String get storagePermissionRequired => 'Storage permission required';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get savingImage => 'Saving image...';

  @override
  String get imageSaved => 'Image saved';

  @override
  String get imageCaptured => '✓ Image captured';

  @override
  String get captureError => '❌ Capture error';

  @override
  String get processingFailed => 'Processing failed';

  @override
  String get modelLoadFailed => 'Failed to load model';

  @override
  String get analysisError => 'Analysis failed';

  @override
  String get detectionAccuracy => 'Detection Accuracy';

  @override
  String get verificationFailed => 'Verification Failed';

  @override
  String get imageOutOfScope => 'Not in supported categories';

  @override
  String get imageOutOfScopeDesc =>
      'This image does not belong to any supported plant categories. Please take a photo of tomato, potato, grape, apple, or corn leaves.';

  @override
  String get lowConfidence => 'Low confidence';

  @override
  String get lowConfidenceDesc =>
      'The AI model is not confident enough about this prediction. Please try:\n• Taking a clearer photo\n• Better lighting\n• Closer to the leaf';

  @override
  String get poorImageQuality => 'Poor image quality';

  @override
  String get poorImageQualityDesc =>
      'The image is too blurry or unclear. Please:\n• Hold the camera steady\n• Ensure good lighting\n• Focus on the leaf';

  @override
  String get imageQualityScore => 'Image Quality';

  @override
  String get retryWithBetterImage => 'Try Again with Better Image';

  @override
  String get highConfidence => 'High Confidence';

  @override
  String get mediumConfidence => 'Medium Confidence';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get autoPlantRecognition => 'Auto plant recognition';

  @override
  String get autoPlantRecognitionDesc =>
      'AI identifies crop species automatically';

  @override
  String get multiDiseaseClassification => 'Multi-disease classification';

  @override
  String get multiDiseaseClassificationDesc => 'Detects various plant diseases';

  @override
  String get instantResults => 'Instant results';

  @override
  String get instantResultsDesc => 'Fast analysis in seconds';

  @override
  String get offlineMode => 'Offline mode';

  @override
  String get offlineModeDesc => 'Works without internet';

  @override
  String get supportedCrops => 'Supported Crops';

  @override
  String get cropVarieties => 'crop varieties';

  @override
  String get diseases => 'diseases';

  @override
  String get aiPowered => 'AI-Powered';

  @override
  String get aiWillIdentify =>
      'AI will identify the crop and detect diseases\nautomatically';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get about => 'About';

  @override
  String get currentlySupported => 'Currently Supported';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get tomato => 'Tomato';

  @override
  String get grape => 'Grape';

  @override
  String get potato => 'Potato';

  @override
  String get apple => 'Apple';

  @override
  String get corn => 'Corn';

  @override
  String get rice => 'Rice';

  @override
  String get bellPepper => 'Bell Pepper';

  @override
  String get strawberry => 'Strawberry';

  @override
  String get soybean => 'Soybean';

  @override
  String get cucumber => 'Cucumber';

  @override
  String get chili => 'Chili';

  @override
  String get moreText => 'more';

  @override
  String get multiCropDetection => 'Multi Crop Detection';

  @override
  String get multiCropDetectionDesc =>
      'Our AI automatically identifies plant species and detects diseases specific to each crop';

  @override
  String get cropsAvailable => 'crops available';

  @override
  String get scanHistory => 'Scan History';

  @override
  String get totalScans => 'total scans';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm =>
      'Are you sure you want to clear all scan history?';

  @override
  String get noScanHistoryYet => 'No scan history yet';

  @override
  String get startScanningToSeeResults => 'Start scanning to see results here';

  @override
  String get clear => 'Clear';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get ourMissionDesc =>
      'Empowering farmers with accessible AI technology for early disease detection';

  @override
  String get howAiWorks => 'How AI Works in Agriculture';

  @override
  String get howAiWorksDesc =>
      'Our AI system is designed to make crop health monitoring accessible and accurate for everyone';

  @override
  String get convolutionalNeuralNetworks => 'Convolutional Neural Networks';

  @override
  String get convolutionalNeuralNetworksDesc =>
      'Advanced deep learning architecture that mimics human vision to analyze plant leaf patterns';

  @override
  String get computerVision => 'Computer Vision';

  @override
  String get computerVisionDesc =>
      'Analyzes visual patterns like spots, discoloration, and texture to identify specific diseases';

  @override
  String get deepLearningTraining => 'Deep Learning Training';

  @override
  String get deepLearningTrainingDesc =>
      'Our model is trained on thousands of labeled crop images to continuously improve accuracy';

  @override
  String get technicalFeatures => 'Technical Features';

  @override
  String get cnnArchitecture => 'Convolutional Neural Networks (CNN)';

  @override
  String get cnnArchitectureDesc => 'Advanced image recognition architecture';

  @override
  String get multiCropSupport => 'Multi Crop Support';

  @override
  String get multiCropSupportDesc => 'Works with multiple crop types';

  @override
  String get highAccuracy => 'High Accuracy';

  @override
  String get highAccuracyDesc => 'Trained on extensive disease datasets';

  @override
  String get realTimeProcessing => 'Real-time Processing';

  @override
  String get realTimeProcessingDesc => 'On-device inference with no delays';

  @override
  String get benefitsOfAi => 'Benefits of AI in Farming';

  @override
  String get earlyDetection => 'Early Detection';

  @override
  String get earlyDetectionDesc =>
      'Catch diseases before visible symptoms appear';

  @override
  String get costEffective => 'Cost-Effective';

  @override
  String get costEffectiveDesc => 'Reduce crop loss and optimize treatments';

  @override
  String get ecoFriendly => 'Eco-Friendly';

  @override
  String get ecoFriendlyDesc => 'Minimize pesticide use with precision farming';

  @override
  String get dataPrivacy => 'Data Privacy';

  @override
  String get dataPrivacyDesc => 'All processing happens locally on your device';

  @override
  String get analysisComplete => 'Analysis Complete';

  @override
  String get aiIdentifiedPlant =>
      'AI has identified the plant and detected disease';

  @override
  String get plantIdentification => 'Plant Identification';

  @override
  String get detectedPlant => 'Detected Plant';

  @override
  String get confidenceScore => 'Confidence Score';

  @override
  String get diseaseDetection => 'Disease Detection';

  @override
  String get modelConfidence => 'Model Confidence';

  @override
  String get quickSummary => 'Quick Summary';

  @override
  String get mainSymptoms => 'Main Symptoms:';

  @override
  String get viewDetailedInformation => 'View Detailed Information';

  @override
  String get scanAnother => 'Scan Another Plant';

  @override
  String get saveToHistory => 'Save to History';

  @override
  String get diseaseDetails => 'Disease Details';

  @override
  String get overview => 'Overview';

  @override
  String get identifiedDisease => 'Identified Disease';

  @override
  String get affectedPlant => 'Affected Plant';

  @override
  String get severityLevel => 'Severity Level';

  @override
  String get detectionConfidence => 'Detection Confidence';

  @override
  String get recommendedActions => 'Recommended Actions';

  @override
  String get urgentAction => 'Urgent Action Required';

  @override
  String get moderateAction => 'Moderate Action Needed';

  @override
  String get lowRisk => 'Low Risk - Monitor';

  @override
  String get severe => 'Severe';

  @override
  String get moderate => 'Moderate';

  @override
  String get mild => 'Mild';

  @override
  String get backToResults => 'Back to Results';

  @override
  String get disclaimer =>
      'Disclaimer: AI-generated result. Please consult agricultural experts for confirmation and treatment.';

  @override
  String get detectedDisease => 'Detected Disease';

  @override
  String get possibleCauses => 'Possible Causes';

  @override
  String get preventionTips => 'Prevention Tips';

  @override
  String get basicTreatmentSuggestions => 'Basic Treatment Suggestions';

  @override
  String get organicOptions => 'Organic Options:';

  @override
  String get chemicalOptions => 'Chemical Options:';

  @override
  String get dataDriven => 'Data-Driven';

  @override
  String get dataDrivenDesc => 'Make informed decisions based on AI insights';

  @override
  String get whoCanUseOurApp => 'Who Can Use Our App?';

  @override
  String get farmersAndGrowers => 'Farmers & Growers';

  @override
  String get farmersAndGrowersDesc => 'Monitor crop health and prevent losses';

  @override
  String get studentsAndResearchers => 'Students & Researchers';

  @override
  String get studentsAndResearchersDesc =>
      'Study plant diseases and AI applications';

  @override
  String get homeGardeners => 'Home Gardeners';

  @override
  String get homeGardenersDesc => 'Keep your garden plants healthy';

  @override
  String get supportInformation => 'Support Information';

  @override
  String get supportInformationDesc =>
      'This app is continuously being improved. We are actively expanding our database to support more crops and diseases.';

  @override
  String get aiAndSmartAgriculture => 'AI & Smart Agriculture';

  @override
  String get moreCropsWillBeAdded =>
      'More crops will be added as our AI continues to learn and improve';

  @override
  String get soon => 'Soon';

  @override
  String get cnnAndDeepLearning => 'CNN & Deep Learning';

  @override
  String get cnnAndDeepLearningDesc =>
      'This app uses a Convolutional Neural Network (CNN) trained on thousands of tomato leaf images to classify diseases with high accuracy.';

  @override
  String get modelPerformance => 'Model Performance';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get trainingDataset => 'Training Dataset';

  @override
  String get diseaseClasses => 'Disease Classes';

  @override
  String get images => 'images';

  @override
  String get types => 'types';

  @override
  String get academicFoundation => 'Academic Foundation';

  @override
  String get academicFoundationDesc =>
      'Based on research in computer vision and smart agriculture, combining deep learning with real farming needs.';

  @override
  String get technologies => 'Technologies';

  @override
  String get deepLearning => 'Deep Learning';

  @override
  String get imageAnalysis => 'Image Analysis';

  @override
  String get mobileUI => 'Mobile UI';

  @override
  String get modelTraining => 'Model Training';

  @override
  String get released => 'Released';

  @override
  String get developedFor =>
      'Developed for academic research and agricultural technology advancement';

  @override
  String get importantDisclaimer => 'Important Disclaimer';

  @override
  String get importantDisclaimerDesc =>
      'This is an AI-generated result based on computer vision analysis. For accurate diagnosis and treatment recommendations, please consult with agricultural experts, extension officers, or certified plant pathologists in your area.';
}

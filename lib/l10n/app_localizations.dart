import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Plant Disease Detection'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @supportedPlants.
  ///
  /// In en, this message translates to:
  /// **'Supported Plants'**
  String get supportedPlants;

  /// No description provided for @aiPlantScanner.
  ///
  /// In en, this message translates to:
  /// **'AI Plant Scanner'**
  String get aiPlantScanner;

  /// No description provided for @scanAnyPlantLeaf.
  ///
  /// In en, this message translates to:
  /// **'Scan Any Plant Leaf'**
  String get scanAnyPlantLeaf;

  /// No description provided for @aiIdentifyDescription.
  ///
  /// In en, this message translates to:
  /// **'AI will identify the crop and detect diseases\nautomatically'**
  String get aiIdentifyDescription;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Take Picture'**
  String get takePicture;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from Gallery'**
  String get selectFromGallery;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// No description provided for @detectionResult.
  ///
  /// In en, this message translates to:
  /// **'Detection Result'**
  String get detectionResult;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @useThisImage.
  ///
  /// In en, this message translates to:
  /// **'Use This Image'**
  String get useThisImage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @diseaseInformation.
  ///
  /// In en, this message translates to:
  /// **'Disease Information'**
  String get diseaseInformation;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get symptoms;

  /// No description provided for @causes.
  ///
  /// In en, this message translates to:
  /// **'Causes'**
  String get causes;

  /// No description provided for @prevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get prevention;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @diseasesDetected.
  ///
  /// In en, this message translates to:
  /// **'Diseases Detected'**
  String get diseasesDetected;

  /// No description provided for @diseasesList.
  ///
  /// In en, this message translates to:
  /// **'Diseases List'**
  String get diseasesList;

  /// No description provided for @diseasesCount.
  ///
  /// In en, this message translates to:
  /// **'diseases'**
  String get diseasesCount;

  /// No description provided for @organicTreatment.
  ///
  /// In en, this message translates to:
  /// **'Organic Treatment'**
  String get organicTreatment;

  /// No description provided for @chemicalTreatment.
  ///
  /// In en, this message translates to:
  /// **'Chemical Treatment'**
  String get chemicalTreatment;

  /// No description provided for @culturalPractices.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices:'**
  String get culturalPractices;

  /// No description provided for @maintenanceTips.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Tips'**
  String get maintenanceTips;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Detection History'**
  String get historyTitle;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No detection history'**
  String get noHistory;

  /// No description provided for @deleteHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get deleteHistory;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteConfirm;

  /// No description provided for @deleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all history?'**
  String get deleteAllConfirm;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item from history?'**
  String get deleteItemConfirm;

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get itemDeleted;

  /// No description provided for @scanDetail.
  ///
  /// In en, this message translates to:
  /// **'Scan Detail'**
  String get scanDetail;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @diseased.
  ///
  /// In en, this message translates to:
  /// **'Diseased'**
  String get diseased;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add your agronomist notes, treatment applied, or environmental context here.'**
  String get notesPlaceholder;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @imageSelected.
  ///
  /// In en, this message translates to:
  /// **'✓ Image selected'**
  String get imageSelected;

  /// No description provided for @imageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// No description provided for @plantName.
  ///
  /// In en, this message translates to:
  /// **'Plant Name'**
  String get plantName;

  /// No description provided for @diseaseName.
  ///
  /// In en, this message translates to:
  /// **'Disease Name'**
  String get diseaseName;

  /// No description provided for @detectedOn.
  ///
  /// In en, this message translates to:
  /// **'Detected on'**
  String get detectedOn;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @selectImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an image first'**
  String get selectImageFirst;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission required'**
  String get cameraPermissionRequired;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission required'**
  String get storagePermissionRequired;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @savingImage.
  ///
  /// In en, this message translates to:
  /// **'Saving image...'**
  String get savingImage;

  /// No description provided for @imageSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved'**
  String get imageSaved;

  /// No description provided for @imageCaptured.
  ///
  /// In en, this message translates to:
  /// **'✓ Image captured'**
  String get imageCaptured;

  /// No description provided for @captureError.
  ///
  /// In en, this message translates to:
  /// **'❌ Capture error'**
  String get captureError;

  /// No description provided for @processingFailed.
  ///
  /// In en, this message translates to:
  /// **'Processing failed'**
  String get processingFailed;

  /// No description provided for @modelLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load model'**
  String get modelLoadFailed;

  /// No description provided for @analysisError.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed'**
  String get analysisError;

  /// No description provided for @detectionAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Detection Accuracy'**
  String get detectionAccuracy;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Verification Failed'**
  String get verificationFailed;

  /// No description provided for @imageOutOfScope.
  ///
  /// In en, this message translates to:
  /// **'Not in supported categories'**
  String get imageOutOfScope;

  /// No description provided for @imageOutOfScopeDesc.
  ///
  /// In en, this message translates to:
  /// **'This image does not belong to any supported plant categories. Please take a photo of tomato, potato, grape, apple, or corn leaves.'**
  String get imageOutOfScopeDesc;

  /// No description provided for @lowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get lowConfidence;

  /// No description provided for @lowConfidenceDesc.
  ///
  /// In en, this message translates to:
  /// **'The AI model is not confident enough about this prediction. Please try:\n• Taking a clearer photo\n• Better lighting\n• Closer to the leaf'**
  String get lowConfidenceDesc;

  /// No description provided for @poorImageQuality.
  ///
  /// In en, this message translates to:
  /// **'Poor image quality'**
  String get poorImageQuality;

  /// No description provided for @poorImageQualityDesc.
  ///
  /// In en, this message translates to:
  /// **'The image is too blurry or unclear. Please:\n• Hold the camera steady\n• Ensure good lighting\n• Focus on the leaf'**
  String get poorImageQualityDesc;

  /// No description provided for @imageQualityScore.
  ///
  /// In en, this message translates to:
  /// **'Image Quality'**
  String get imageQualityScore;

  /// No description provided for @retryWithBetterImage.
  ///
  /// In en, this message translates to:
  /// **'Try Again with Better Image'**
  String get retryWithBetterImage;

  /// No description provided for @highConfidence.
  ///
  /// In en, this message translates to:
  /// **'High Confidence'**
  String get highConfidence;

  /// No description provided for @mediumConfidence.
  ///
  /// In en, this message translates to:
  /// **'Medium Confidence'**
  String get mediumConfidence;

  /// No description provided for @keyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// No description provided for @autoPlantRecognition.
  ///
  /// In en, this message translates to:
  /// **'Auto plant recognition'**
  String get autoPlantRecognition;

  /// No description provided for @autoPlantRecognitionDesc.
  ///
  /// In en, this message translates to:
  /// **'AI identifies crop species automatically'**
  String get autoPlantRecognitionDesc;

  /// No description provided for @multiDiseaseClassification.
  ///
  /// In en, this message translates to:
  /// **'Multi-disease classification'**
  String get multiDiseaseClassification;

  /// No description provided for @multiDiseaseClassificationDesc.
  ///
  /// In en, this message translates to:
  /// **'Detects various plant diseases'**
  String get multiDiseaseClassificationDesc;

  /// No description provided for @instantResults.
  ///
  /// In en, this message translates to:
  /// **'Instant results'**
  String get instantResults;

  /// No description provided for @instantResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast analysis in seconds'**
  String get instantResultsDesc;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineMode;

  /// No description provided for @offlineModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Works without internet'**
  String get offlineModeDesc;

  /// No description provided for @supportedCrops.
  ///
  /// In en, this message translates to:
  /// **'Supported Crops'**
  String get supportedCrops;

  /// No description provided for @cropVarieties.
  ///
  /// In en, this message translates to:
  /// **'crop varieties'**
  String get cropVarieties;

  /// No description provided for @diseases.
  ///
  /// In en, this message translates to:
  /// **'diseases'**
  String get diseases;

  /// No description provided for @aiPowered.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered'**
  String get aiPowered;

  /// No description provided for @aiWillIdentify.
  ///
  /// In en, this message translates to:
  /// **'AI will identify the crop and detect diseases\nautomatically'**
  String get aiWillIdentify;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @currentlySupported.
  ///
  /// In en, this message translates to:
  /// **'Currently Supported'**
  String get currentlySupported;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @tomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get tomato;

  /// No description provided for @grape.
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get grape;

  /// No description provided for @potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @corn.
  ///
  /// In en, this message translates to:
  /// **'Corn'**
  String get corn;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @bellPepper.
  ///
  /// In en, this message translates to:
  /// **'Bell Pepper'**
  String get bellPepper;

  /// No description provided for @strawberry.
  ///
  /// In en, this message translates to:
  /// **'Strawberry'**
  String get strawberry;

  /// No description provided for @soybean.
  ///
  /// In en, this message translates to:
  /// **'Soybean'**
  String get soybean;

  /// No description provided for @cucumber.
  ///
  /// In en, this message translates to:
  /// **'Cucumber'**
  String get cucumber;

  /// No description provided for @chili.
  ///
  /// In en, this message translates to:
  /// **'Chili'**
  String get chili;

  /// No description provided for @moreText.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get moreText;

  /// No description provided for @multiCropDetection.
  ///
  /// In en, this message translates to:
  /// **'Multi Crop Detection'**
  String get multiCropDetection;

  /// No description provided for @multiCropDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI automatically identifies plant species and detects diseases specific to each crop'**
  String get multiCropDetectionDesc;

  /// No description provided for @cropsAvailable.
  ///
  /// In en, this message translates to:
  /// **'crops available'**
  String get cropsAvailable;

  /// No description provided for @scanHistory.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get scanHistory;

  /// No description provided for @totalScans.
  ///
  /// In en, this message translates to:
  /// **'total scans'**
  String get totalScans;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all scan history?'**
  String get clearHistoryConfirm;

  /// No description provided for @noScanHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No scan history yet'**
  String get noScanHistoryYet;

  /// No description provided for @startScanningToSeeResults.
  ///
  /// In en, this message translates to:
  /// **'Start scanning to see results here'**
  String get startScanningToSeeResults;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @ourMissionDesc.
  ///
  /// In en, this message translates to:
  /// **'Empowering farmers with accessible AI technology for early disease detection'**
  String get ourMissionDesc;

  /// No description provided for @howAiWorks.
  ///
  /// In en, this message translates to:
  /// **'How AI Works in Agriculture'**
  String get howAiWorks;

  /// No description provided for @howAiWorksDesc.
  ///
  /// In en, this message translates to:
  /// **'Our AI system is designed to make crop health monitoring accessible and accurate for everyone'**
  String get howAiWorksDesc;

  /// No description provided for @convolutionalNeuralNetworks.
  ///
  /// In en, this message translates to:
  /// **'Convolutional Neural Networks'**
  String get convolutionalNeuralNetworks;

  /// No description provided for @convolutionalNeuralNetworksDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced deep learning architecture that mimics human vision to analyze plant leaf patterns'**
  String get convolutionalNeuralNetworksDesc;

  /// No description provided for @computerVision.
  ///
  /// In en, this message translates to:
  /// **'Computer Vision'**
  String get computerVision;

  /// No description provided for @computerVisionDesc.
  ///
  /// In en, this message translates to:
  /// **'Analyzes visual patterns like spots, discoloration, and texture to identify specific diseases'**
  String get computerVisionDesc;

  /// No description provided for @deepLearningTraining.
  ///
  /// In en, this message translates to:
  /// **'Deep Learning Training'**
  String get deepLearningTraining;

  /// No description provided for @deepLearningTrainingDesc.
  ///
  /// In en, this message translates to:
  /// **'Our model is trained on thousands of labeled crop images to continuously improve accuracy'**
  String get deepLearningTrainingDesc;

  /// No description provided for @technicalFeatures.
  ///
  /// In en, this message translates to:
  /// **'Technical Features'**
  String get technicalFeatures;

  /// No description provided for @cnnArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Convolutional Neural Networks (CNN)'**
  String get cnnArchitecture;

  /// No description provided for @cnnArchitectureDesc.
  ///
  /// In en, this message translates to:
  /// **'Advanced image recognition architecture'**
  String get cnnArchitectureDesc;

  /// No description provided for @multiCropSupport.
  ///
  /// In en, this message translates to:
  /// **'Multi Crop Support'**
  String get multiCropSupport;

  /// No description provided for @multiCropSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Works with multiple crop types'**
  String get multiCropSupportDesc;

  /// No description provided for @highAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High Accuracy'**
  String get highAccuracy;

  /// No description provided for @highAccuracyDesc.
  ///
  /// In en, this message translates to:
  /// **'Trained on extensive disease datasets'**
  String get highAccuracyDesc;

  /// No description provided for @realTimeProcessing.
  ///
  /// In en, this message translates to:
  /// **'Real-time Processing'**
  String get realTimeProcessing;

  /// No description provided for @realTimeProcessingDesc.
  ///
  /// In en, this message translates to:
  /// **'On-device inference with no delays'**
  String get realTimeProcessingDesc;

  /// No description provided for @benefitsOfAi.
  ///
  /// In en, this message translates to:
  /// **'Benefits of AI in Farming'**
  String get benefitsOfAi;

  /// No description provided for @earlyDetection.
  ///
  /// In en, this message translates to:
  /// **'Early Detection'**
  String get earlyDetection;

  /// No description provided for @earlyDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Catch diseases before visible symptoms appear'**
  String get earlyDetectionDesc;

  /// No description provided for @costEffective.
  ///
  /// In en, this message translates to:
  /// **'Cost-Effective'**
  String get costEffective;

  /// No description provided for @costEffectiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Reduce crop loss and optimize treatments'**
  String get costEffectiveDesc;

  /// No description provided for @ecoFriendly.
  ///
  /// In en, this message translates to:
  /// **'Eco-Friendly'**
  String get ecoFriendly;

  /// No description provided for @ecoFriendlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimize pesticide use with precision farming'**
  String get ecoFriendlyDesc;

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data Privacy'**
  String get dataPrivacy;

  /// No description provided for @dataPrivacyDesc.
  ///
  /// In en, this message translates to:
  /// **'All processing happens locally on your device'**
  String get dataPrivacyDesc;

  /// No description provided for @analysisComplete.
  ///
  /// In en, this message translates to:
  /// **'Analysis Complete'**
  String get analysisComplete;

  /// No description provided for @aiIdentifiedPlant.
  ///
  /// In en, this message translates to:
  /// **'AI has identified the plant and detected disease'**
  String get aiIdentifiedPlant;

  /// No description provided for @plantIdentification.
  ///
  /// In en, this message translates to:
  /// **'Plant Identification'**
  String get plantIdentification;

  /// No description provided for @detectedPlant.
  ///
  /// In en, this message translates to:
  /// **'Detected Plant'**
  String get detectedPlant;

  /// No description provided for @confidenceScore.
  ///
  /// In en, this message translates to:
  /// **'Confidence Score'**
  String get confidenceScore;

  /// No description provided for @diseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get diseaseDetection;

  /// No description provided for @modelConfidence.
  ///
  /// In en, this message translates to:
  /// **'Model Confidence'**
  String get modelConfidence;

  /// No description provided for @quickSummary.
  ///
  /// In en, this message translates to:
  /// **'Quick Summary'**
  String get quickSummary;

  /// No description provided for @mainSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Main Symptoms:'**
  String get mainSymptoms;

  /// No description provided for @viewDetailedInformation.
  ///
  /// In en, this message translates to:
  /// **'View Detailed Information'**
  String get viewDetailedInformation;

  /// No description provided for @scanAnother.
  ///
  /// In en, this message translates to:
  /// **'Scan Another Plant'**
  String get scanAnother;

  /// No description provided for @saveToHistory.
  ///
  /// In en, this message translates to:
  /// **'Save to History'**
  String get saveToHistory;

  /// No description provided for @diseaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Disease Details'**
  String get diseaseDetails;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @identifiedDisease.
  ///
  /// In en, this message translates to:
  /// **'Identified Disease'**
  String get identifiedDisease;

  /// No description provided for @affectedPlant.
  ///
  /// In en, this message translates to:
  /// **'Affected Plant'**
  String get affectedPlant;

  /// No description provided for @severityLevel.
  ///
  /// In en, this message translates to:
  /// **'Severity Level'**
  String get severityLevel;

  /// No description provided for @detectionConfidence.
  ///
  /// In en, this message translates to:
  /// **'Detection Confidence'**
  String get detectionConfidence;

  /// No description provided for @recommendedActions.
  ///
  /// In en, this message translates to:
  /// **'Recommended Actions'**
  String get recommendedActions;

  /// No description provided for @urgentAction.
  ///
  /// In en, this message translates to:
  /// **'Urgent Action Required'**
  String get urgentAction;

  /// No description provided for @moderateAction.
  ///
  /// In en, this message translates to:
  /// **'Moderate Action Needed'**
  String get moderateAction;

  /// No description provided for @lowRisk.
  ///
  /// In en, this message translates to:
  /// **'Low Risk - Monitor'**
  String get lowRisk;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severe;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @backToResults.
  ///
  /// In en, this message translates to:
  /// **'Back to Results'**
  String get backToResults;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: AI-generated result. Please consult agricultural experts for confirmation and treatment.'**
  String get disclaimer;

  /// No description provided for @detectedDisease.
  ///
  /// In en, this message translates to:
  /// **'Detected Disease'**
  String get detectedDisease;

  /// No description provided for @possibleCauses.
  ///
  /// In en, this message translates to:
  /// **'Possible Causes'**
  String get possibleCauses;

  /// No description provided for @preventionTips.
  ///
  /// In en, this message translates to:
  /// **'Prevention Tips'**
  String get preventionTips;

  /// No description provided for @basicTreatmentSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Basic Treatment Suggestions'**
  String get basicTreatmentSuggestions;

  /// No description provided for @organicOptions.
  ///
  /// In en, this message translates to:
  /// **'Organic Options:'**
  String get organicOptions;

  /// No description provided for @chemicalOptions.
  ///
  /// In en, this message translates to:
  /// **'Chemical Options:'**
  String get chemicalOptions;

  /// No description provided for @dataDriven.
  ///
  /// In en, this message translates to:
  /// **'Data-Driven'**
  String get dataDriven;

  /// No description provided for @dataDrivenDesc.
  ///
  /// In en, this message translates to:
  /// **'Make informed decisions based on AI insights'**
  String get dataDrivenDesc;

  /// No description provided for @whoCanUseOurApp.
  ///
  /// In en, this message translates to:
  /// **'Who Can Use Our App?'**
  String get whoCanUseOurApp;

  /// No description provided for @farmersAndGrowers.
  ///
  /// In en, this message translates to:
  /// **'Farmers & Growers'**
  String get farmersAndGrowers;

  /// No description provided for @farmersAndGrowersDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor crop health and prevent losses'**
  String get farmersAndGrowersDesc;

  /// No description provided for @studentsAndResearchers.
  ///
  /// In en, this message translates to:
  /// **'Students & Researchers'**
  String get studentsAndResearchers;

  /// No description provided for @studentsAndResearchersDesc.
  ///
  /// In en, this message translates to:
  /// **'Study plant diseases and AI applications'**
  String get studentsAndResearchersDesc;

  /// No description provided for @homeGardeners.
  ///
  /// In en, this message translates to:
  /// **'Home Gardeners'**
  String get homeGardeners;

  /// No description provided for @homeGardenersDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep your garden plants healthy'**
  String get homeGardenersDesc;

  /// No description provided for @supportInformation.
  ///
  /// In en, this message translates to:
  /// **'Support Information'**
  String get supportInformation;

  /// No description provided for @supportInformationDesc.
  ///
  /// In en, this message translates to:
  /// **'This app is continuously being improved. We are actively expanding our database to support more crops and diseases.'**
  String get supportInformationDesc;

  /// No description provided for @aiAndSmartAgriculture.
  ///
  /// In en, this message translates to:
  /// **'AI & Smart Agriculture'**
  String get aiAndSmartAgriculture;

  /// No description provided for @moreCropsWillBeAdded.
  ///
  /// In en, this message translates to:
  /// **'More crops will be added as our AI continues to learn and improve'**
  String get moreCropsWillBeAdded;

  /// No description provided for @soon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get soon;

  /// No description provided for @cnnAndDeepLearning.
  ///
  /// In en, this message translates to:
  /// **'CNN & Deep Learning'**
  String get cnnAndDeepLearning;

  /// No description provided for @cnnAndDeepLearningDesc.
  ///
  /// In en, this message translates to:
  /// **'This app uses a Convolutional Neural Network (CNN) trained on thousands of tomato leaf images to classify diseases with high accuracy.'**
  String get cnnAndDeepLearningDesc;

  /// No description provided for @modelPerformance.
  ///
  /// In en, this message translates to:
  /// **'Model Performance'**
  String get modelPerformance;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @trainingDataset.
  ///
  /// In en, this message translates to:
  /// **'Training Dataset'**
  String get trainingDataset;

  /// No description provided for @diseaseClasses.
  ///
  /// In en, this message translates to:
  /// **'Disease Classes'**
  String get diseaseClasses;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'images'**
  String get images;

  /// No description provided for @types.
  ///
  /// In en, this message translates to:
  /// **'types'**
  String get types;

  /// No description provided for @academicFoundation.
  ///
  /// In en, this message translates to:
  /// **'Academic Foundation'**
  String get academicFoundation;

  /// No description provided for @academicFoundationDesc.
  ///
  /// In en, this message translates to:
  /// **'Based on research in computer vision and smart agriculture, combining deep learning with real farming needs.'**
  String get academicFoundationDesc;

  /// No description provided for @technologies.
  ///
  /// In en, this message translates to:
  /// **'Technologies'**
  String get technologies;

  /// No description provided for @deepLearning.
  ///
  /// In en, this message translates to:
  /// **'Deep Learning'**
  String get deepLearning;

  /// No description provided for @imageAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Image Analysis'**
  String get imageAnalysis;

  /// No description provided for @mobileUI.
  ///
  /// In en, this message translates to:
  /// **'Mobile UI'**
  String get mobileUI;

  /// No description provided for @modelTraining.
  ///
  /// In en, this message translates to:
  /// **'Model Training'**
  String get modelTraining;

  /// No description provided for @released.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get released;

  /// No description provided for @developedFor.
  ///
  /// In en, this message translates to:
  /// **'Developed for academic research and agricultural technology advancement'**
  String get developedFor;

  /// No description provided for @importantDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Important Disclaimer'**
  String get importantDisclaimer;

  /// No description provided for @importantDisclaimerDesc.
  ///
  /// In en, this message translates to:
  /// **'This is an AI-generated result based on computer vision analysis. For accurate diagnosis and treatment recommendations, please consult with agricultural experts, extension officers, or certified plant pathologists in your area.'**
  String get importantDisclaimerDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

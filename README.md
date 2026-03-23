# Flutter Deep Learning Android App Scaffold

A lightweight Flutter scaffold for an Android-focused deep learning demo. It includes a clean folder layout, Riverpod state management, TensorFlow Lite integration hook, and placeholders for models/assets.

## Structure
- `lib/main.dart`: App entry with routing and theme.
- `lib/core/`: App-wide config and theming.
- `lib/services/tflite_service.dart`: TensorFlow Lite loader/inference stub.
- `lib/features/inference/`: UI, state, and models for running inference.
- `assets/models/`: Place your `.tflite` models here.
- `assets/images/`: Sample images for testing inference.
- `test/`: Add widget/unit tests.

## Getting started
1. Install Flutter SDK and Android toolchain.
2. Run `flutter pub get`.
3. Add your TFLite model to `assets/models/` and update `pubspec.yaml` assets list if the filename changes.
4. Implement model-specific preprocessing/postprocessing in `TFLiteService` and wire UI in `DeepLearningHomePage`.
5. Run on Android: `flutter run -d android`.

## Notes
- Riverpod is used for simple, testable state management.
- The TFLite code is stubbed; replace `model.tflite` and tensor shapes per your model.

## Firebase Google Login setup
1. Create Firebase project and enable `Authentication -> Sign-in method -> Google`.
2. Add Android app in Firebase Console using package name from `android/app/build.gradle.kts` (`applicationId`).
3. Download `google-services.json` and place it at `android/app/google-services.json`.
4. For iOS, add iOS app in Firebase and place `GoogleService-Info.plist` into `ios/Runner/`.
5. Run `flutter pub get` then `flutter run`.

If Google login shows `ApiException: 10`, check SHA-1/SHA-256 fingerprints in Firebase Android app settings.

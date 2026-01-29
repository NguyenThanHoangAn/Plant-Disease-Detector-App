# Hướng dẫn sử dụng tính năng đa ngôn ngữ / Multilingual Feature Guide

## Tổng quan / Overview

Ứng dụng hiện đã được tích hợp tính năng chuyển đổi ngôn ngữ giữa **Tiếng Việt (VI)** và **Tiếng Anh (EN)**.

The app now supports language switching between **Vietnamese (VI)** and **English (EN)**.

## Các thay đổi đã thực hiện / Changes Made

### 1. Cấu hình Dependencies

**File: `pubspec.yaml`**
- Đã thêm `flutter_localizations` và `flutter.generate: true`
- Cập nhật phiên bản `intl` lên `^0.20.0`

### 2. Cấu hình Localization

**File: `l10n.yaml`**
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### 3. File ngôn ngữ / Translation Files

**File: `lib/l10n/app_en.arb`** - Tiếng Anh
**File: `lib/l10n/app_vi.arb`** - Tiếng Việt

Các file này chứa tất cả các chuỗi văn bản được dịch cho ứng dụng.

### 4. Provider quản lý ngôn ngữ / Language Provider

**File: `lib/core/providers/locale_provider.dart`**
- Provider Riverpod để quản lý ngôn ngữ hiện tại
- Lưu trữ lựa chọn ngôn ngữ vào SharedPreferences
- Hỗ trợ chuyển đổi và thay đổi ngôn ngữ

### 5. Widget chuyển đổi ngôn ngữ / Language Switcher Widget

**File: `lib/features/inference/presentation/widgets/language_switcher.dart`**
- `LanguageSwitcher`: Hiển thị dialog để chọn ngôn ngữ
- `LanguageToggleButton`: Nút chuyển đổi nhanh giữa VI/EN

### 6. Cập nhật Main App

**File: `lib/main.dart`**
- Tích hợp localization delegates
- Hỗ trợ cả tiếng Việt và tiếng Anh
- Theo dõi và cập nhật locale từ provider

## Cách sử dụng / How to Use

### Chạy lần đầu / First Run

1. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```

2. **Chạy ứng dụng (tự động tạo file localization):**
   ```bash
   flutter run
   ```
   
   Hoặc build để tạo file localization:
   ```bash
   flutter build apk
   ```

### Chuyển đổi ngôn ngữ trong app / Switch Language in App

1. Mở ứng dụng
2. Trên màn hình chính, nhấn vào nút ngôn ngữ (biểu tượng **VI** hoặc **EN**) ở góc trên bên phải
3. Chọn ngôn ngữ mong muốn
4. Ứng dụng sẽ tự động cập nhật ngay lập tức

### Thêm văn bản mới cần dịch / Add New Translations

1. Mở `lib/l10n/app_en.arb` và thêm key mới:
   ```json
   {
     "newKey": "English text",
     "@newKey": {
       "description": "Description of the text"
     }
   }
   ```

2. Mở `lib/l10n/app_vi.arb` và thêm bản dịch tiếng Việt:
   ```json
   {
     "newKey": "Văn bản tiếng Việt"
   }
   ```

3. Sử dụng trong code:
   ```dart
   import 'package:flutter_gen/gen_l10n/app_localizations.dart';
   
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.newKey)
   ```

4. Chạy lại ứng dụng để tạo file localization mới:
   ```bash
   flutter run
   ```

## Các từ khóa đã có / Available Keys

Một số key quan trọng đã được thêm:

- `appTitle`: Tiêu đề ứng dụng
- `home`, `history`, `info`: Các tab điều hướng
- `takePicture`, `selectFromGallery`: Các hành động
- `analyzing`, `pleaseWait`: Trạng thái
- `detectionResult`, `confidence`: Kết quả
- `symptoms`, `causes`, `prevention`, `treatment`: Thông tin bệnh
- `language`, `changeLanguage`, `vietnamese`, `english`: Cài đặt ngôn ngữ

Xem đầy đủ trong `lib/l10n/app_en.arb` và `lib/l10n/app_vi.arb`.

## Lưu ý kỹ thuật / Technical Notes

### Tự động tạo file localization / Auto-generation

File `app_localizations.dart` sẽ được tự động tạo tại:
```
.dart_tool/flutter_gen/gen_l10n/app_localizations.dart
```

File này được tạo khi:
- Chạy `flutter run`
- Chạy `flutter build`
- IDE tự động build (VS Code, Android Studio)

### Import trong code / Import in Code

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### Sử dụng trong Widget / Use in Widget

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.appTitle);
}
```

### Truy cập locale hiện tại / Access Current Locale

```dart
// With Riverpod
final locale = ref.watch(localeProvider);

// hoặc / or
final languageCode = Localizations.localeOf(context).languageCode;
```

## Troubleshooting

### Lỗi: "Target of URI doesn't exist"

Nếu gặp lỗi import `app_localizations.dart`:
1. Chạy `flutter clean`
2. Chạy `flutter pub get`
3. Chạy `flutter run` hoặc `flutter build`

### Ngôn ngữ không thay đổi

1. Kiểm tra provider đã được setup trong `ProviderScope`
2. Đảm bảo `MaterialApp` đang watch `localeProvider`
3. Xóa cache của SharedPreferences nếu cần

## Tài liệu tham khảo / References

- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [Riverpod Documentation](https://riverpod.dev/)
- [ARB Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)

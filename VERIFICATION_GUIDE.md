# Hướng dẫn Verification System

## 📋 Tổng quan

Hệ thống verification được thêm vào để đảm bảo chất lượng phân tích bệnh cây trồng. Hệ thống kiểm tra 3 yếu tố chính trước khi trả về kết quả cho người dùng.

## 🔍 Các Loại Verification

### 1. **Kiểm tra Chất lượng Ảnh (Image Quality Check)**
- **Trường hợp**: Ảnh mờ / lỗi
- **Phương pháp**: Laplacian Variance (Blur Detection)
- **Threshold**: Score < 30/100
- **Message**: "Ảnh không đạt chất lượng"
- **File**: `lib/services/image_quality_service.dart`

**Cách hoạt động**:
```dart
// Tính Laplacian variance để phát hiện blur
// Score càng cao = ảnh càng rõ nét
// Score < 30 = ảnh quá mờ → Reject
final qualityResult = await _qualityService.checkImageQuality(imageFile);
if (!qualityResult.isGoodQuality) {
  return VerificationResult.failed(
    error: VerificationError.poorQuality,
    imageQualityScore: qualityResult.blurScore,
  );
}
```

### 2. **Kiểm tra Độ Tin Cậy (Confidence Check)**
- **Trường hợp**: Confidence thấp
- **Threshold**: < 60%
- **Message**: "Không đủ độ tin cậy"
- **File**: `lib/services/tflite_service.dart`

**Cách hoạt động**:
```dart
const confidenceThreshold = 0.60; // 60%

if (topResult.confidence < confidenceThreshold) {
  return VerificationResult.failed(
    error: VerificationError.lowConfidence,
    message: 'Độ tin cậy: ${(topResult.confidence * 100).toStringAsFixed(1)}%',
  );
}
```

### 3. **Kiểm tra Ngoài Phạm Vi (Out-of-Scope Detection)**
- **Trường hợp**: Ảnh không thuộc danh mục hỗ trợ
- **Phương pháp**: OOD (Out-of-Distribution) Detection
- **Message**: "Không thuộc danh mục hỗ trợ"
- **File**: `lib/services/tflite_service.dart`

**Cách hoạt động - 3 checks**:

#### Check 1: Max Probability quá thấp
```dart
// Nếu prediction tốt nhất < 40% → likely OOD
const maxProbThresholdLow = 0.40;
if (topResult.confidence < maxProbThresholdLow) {
  return true; // Out of scope
}
```

#### Check 2: Entropy cao (phân bố đều)
```dart
// Tính entropy: -Σ(p * log(p))
// Entropy cao = không thuộc class nào rõ ràng
double entropy = 0;
for (final pred in predictions) {
  if (pred.confidence > 0) {
    entropy -= pred.confidence * math.log(pred.confidence) / math.ln2;
  }
}

// Normalize về 0-1
final normalizedEntropy = entropy / maxEntropy;

// Nếu entropy > 0.8 → likely OOD
if (normalizedEntropy > 0.80) {
  return true; // Out of scope
}
```

#### Check 3: Gap giữa top-1 và top-2 quá nhỏ
```dart
// Nếu chênh lệch giữa top-1 và top-2 < 10% → uncertain
const minGap = 0.10;
if (predictions.length >= 2) {
  final gap = topResult.confidence - predictions[1].confidence;
  if (gap < minGap) {
    return true; // Out of scope
  }
}
```

## 📁 Cấu trúc File

```
lib/
├── services/
│   ├── image_quality_service.dart    ✨ MỚI - Kiểm tra chất lượng ảnh
│   └── tflite_service.dart           📝 Updated - Thêm runWithVerification()
├── features/inference/
│   ├── domain/models/
│   │   └── verification_result.dart  ✨ MỚI - Model cho verification
│   ├── application/
│   │   └── inference_notifier.dart   📝 Updated - Sử dụng VerificationResult
│   └── presentation/pages/
│       └── home_page.dart            📝 Updated - Hiển thị lỗi verification
└── l10n/
    ├── app_en.arb                    📝 Updated - Thêm messages
    └── app_vi.arb                    📝 Updated - Thêm messages
```

## 🔄 Flow Hoạt Động

```
User chụp ảnh
     ↓
InferenceNotifier.runInference()
     ↓
TFLiteService.runWithVerification()
     ↓
┌────────────────────────────────┐
│ 1. Check Image Quality         │
│    ImageQualityService         │
│    → Blur detection            │
└────────────────────────────────┘
     ↓ Pass
┌────────────────────────────────┐
│ 2. Run TFLite Model            │
│    → Get predictions           │
└────────────────────────────────┘
     ↓
┌────────────────────────────────┐
│ 3. Check Confidence            │
│    → Must be >= 60%            │
└────────────────────────────────┘
     ↓ Pass
┌────────────────────────────────┐
│ 4. Check Out-of-Scope          │
│    → Entropy-based OOD         │
└────────────────────────────────┘
     ↓ Pass
VerificationResult.passed()
     ↓
Navigate to ResultDetailPage

     [Nếu Fail bất kỳ bước nào]
     ↓
VerificationResult.failed()
     ↓
Show error dialog với hướng dẫn
```

## 🎨 UI/UX

### Dialog Lỗi Verification

Khi verification fail, hiển thị dialog với:

1. **Icon màu sắc phù hợp**:
   - 🟠 Blur: Orange - `Icons.blur_on`
   - 🟡 Low confidence: Amber - `Icons.error_outline`
   - 🔴 Out of scope: Red - `Icons.cancel`

2. **Tiêu đề rõ ràng**:
   - "Ảnh không đạt chất lượng"
   - "Không đủ độ tin cậy"
   - "Không thuộc danh mục hỗ trợ"

3. **Mô tả chi tiết** với hướng dẫn cụ thể

4. **Image Quality Score** (nếu có)

5. **Nút "Thử lại với ảnh tốt hơn"**

## ⚙️ Cấu hình Thresholds

Có thể điều chỉnh các ngưỡng trong code:

### Image Quality (`image_quality_service.dart`)
```dart
// Line 48
final isGoodQuality = normalizedScore >= 30; // Threshold
```

### Confidence (`tflite_service.dart`)
```dart
// Line 342
const confidenceThreshold = 0.60; // 60%
```

### Out-of-Scope Detection (`tflite_service.dart`)
```dart
// Line 384 - Max prob threshold
const maxProbThresholdLow = 0.40;

// Line 402 - Entropy threshold
const entropyThreshold = 0.80;

// Line 409 - Gap threshold
const minGap = 0.10;
```

## 📊 Testing

### Test Case 1: Ảnh mờ
```
1. Chụp ảnh cố tình mờ (lắc camera)
2. Expected: Dialog "Ảnh không đạt chất lượng"
3. Quality score sẽ < 30
```

### Test Case 2: Low Confidence
```
1. Chụp ảnh lá cây không rõ ràng hoặc góc nghiêng
2. Expected: Dialog "Không đủ độ tin cậy"
3. Confidence sẽ < 60%
```

### Test Case 3: Out of Scope
```
1. Chụp ảnh không phải lá cây (người, xe, vật thể)
2. Expected: Dialog "Không thuộc danh mục hỗ trợ"
3. Entropy cao hoặc max prob thấp
```

### Test Case 4: Pass All Checks
```
1. Chụp ảnh lá cây rõ nét, đúng góc
2. Expected: Navigate to ResultDetailPage
3. Hiển thị kết quả phân tích bình thường
```

## 🐛 Debugging

Enable debug logs trong console:

```dart
// Image Quality
print('🔍 [ImageQuality] Đang kiểm tra chất lượng ảnh...');
print('   📊 Blur score: ${normalizedScore.toStringAsFixed(1)}');

// Confidence Check
print('🏆 [Verification] Top prediction: ${topResult.label} (${confidence}%)');
print('⚠️  [Verification] Confidence thấp: ${confidence}% < 60%');

// OOD Detection
print('   🔍 OOD check: entropy=${entropy.toFixed(3)}, maxProb=${maxProb}%');
print('❌ [Verification] Ảnh ngoài phạm vi hỗ trợ');
```

## 🔧 Troubleshooting

### Vấn đề: Tất cả ảnh đều bị reject
**Giải pháp**: Giảm thresholds xuống thấp hơn

### Vấn đề: Ảnh mờ vẫn pass
**Giải pháp**: Tăng threshold quality từ 30 lên 40-50

### Vấn đề: Too many false OOD detections
**Giải pháp**: 
- Giảm entropy threshold từ 0.80 xuống 0.85
- Giảm minGap từ 0.10 xuống 0.05

## 📝 Localization Keys

Các key đã thêm vào `app_en.arb` và `app_vi.arb`:

```json
{
  "verificationFailed": "...",
  "imageOutOfScope": "...",
  "imageOutOfScopeDesc": "...",
  "lowConfidence": "...",
  "lowConfidenceDesc": "...",
  "poorImageQuality": "...",
  "poorImageQualityDesc": "...",
  "imageQualityScore": "...",
  "retryWithBetterImage": "..."
}
```

## 🎯 Best Practices

1. **Fail Fast**: Kiểm tra quality trước để tiết kiệm thời gian inference
2. **User-Friendly**: Luôn cung cấp hướng dẫn cụ thể khi reject
3. **Logging**: Log đầy đủ để debug dễ dàng
4. **Fail-Safe**: Nếu lỗi khi check quality → cho phép tiếp tục
5. **Performance**: Resize ảnh xuống 640px khi check quality để nhanh hơn

## 🚀 Future Improvements

1. **ML-based OOD**: Train thêm outlier detection model
2. **Feedback Loop**: Thu thập ảnh bị reject để improve model
3. **Adjustable Thresholds**: Cho user điều chỉnh độ nghiêm ngặt
4. **More Checks**: Kiểm tra lighting, color distribution, etc.
5. **Analytics**: Track tỷ lệ pass/fail để optimize thresholds

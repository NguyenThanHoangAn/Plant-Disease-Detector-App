import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_deep_learning_demo/services/history_service.dart';
import 'package:flutter_deep_learning_demo/services/tflite_service.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/verification_result.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/presentation/view/history_page.dart';

final inferenceProvider = StateNotifierProvider<InferenceNotifier, AsyncValue<VerificationResult?>>(
  (ref) => InferenceNotifier(
    ref.read(tfliteServiceProvider),
    ref.read(historyServiceProvider),
    ref,
  ),
);

class InferenceNotifier extends StateNotifier<AsyncValue<VerificationResult?>> {
  InferenceNotifier(this._service, this._historyService, this._ref) : super(const AsyncValue.data(null));

  final TFLiteService _service;
  final HistoryService _historyService;
  final Ref _ref;

  Future<void> runInference(File image) async {
    // ✅ BƯỚC 1: Kiểm tra ảnh
    if (!image.existsSync()) {
      print('❌ [InferenceNotifier] Ảnh không tồn tại: ${image.path}');
      state = AsyncValue.error(Exception('Ảnh không tồn tại'), StackTrace.current);
      return;
    }

    print('📊 [InferenceNotifier] Bắt đầu inference với verification');
    print('   📁 Ảnh: ${image.path}');
    print('   📏 Kích thước: ${image.lengthSync()} bytes');

    state = const AsyncValue.loading();
    try {
      // ✅ BƯỚC 2: Chạy inference với verification
      print('🔒 [InferenceNotifier] Chạy model với đầy đủ verification...');
      final verificationResult = await _service.runWithVerification(image);
      
      print('✅ [InferenceNotifier] Verification xong!');
      print('   🔍 Kết quả: ${verificationResult.isPassed ? "✅ PASS" : "❌ FAIL (${verificationResult.error})"}');
      
      if (verificationResult.isPassed && verificationResult.predictions.isNotEmpty) {
        print('   🏆 Top kết quả:');
        for (var i = 0; i < 3 && i < verificationResult.predictions.length; i++) {
          final pred = verificationResult.predictions[i];
          print('      [$i] ${pred.label} - ${(pred.confidence * 100).toStringAsFixed(1)}%');
        }
      } else {
        print('   ⚠️  Lý do: ${verificationResult.message}');
      }

      state = AsyncValue.data(verificationResult);

      // ✅ BƯỚC 3: Lưu vào history (chỉ khi pass verification)
      if (verificationResult.isPassed && verificationResult.predictions.isNotEmpty) {
        final topResult = verificationResult.predictions.first;
        final now = DateTime.now();
        final dateFormat = DateFormat('yyyy-MM-dd');
        final timeFormat = DateFormat('hh:mm a');

        final historyItem = ScanHistoryItem(
          id: _historyService.getNextId(),
          diseaseName: topResult.label,
          status: topResult.label.toLowerCase().contains('healthy') ? 'healthy' : 'diseased',
          confidence: (topResult.confidence * 100).roundToDouble(),
          date: dateFormat.format(now),
          time: timeFormat.format(now),
          imagePath: image.path,
        );

        await _historyService.addHistoryItem(historyItem);
        print('💾 [InferenceNotifier] Đã lưu vào history');
        
        // ✅ BƯỚC 4: Refresh history provider
        _ref.read(historyProvider.notifier).refresh();
        print('🔄 [InferenceNotifier] Đã refresh history view');
      } else {
        print('⚠️  [InferenceNotifier] Không lưu history (verification failed)');
      }
    } catch (e, st) {
      print('❌ [InferenceNotifier] Lỗi inference: $e');
      print('   Stack: $st');
      state = AsyncValue.error(e, st);
    }
  }
}

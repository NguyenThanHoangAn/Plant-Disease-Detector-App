import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../services/history_service.dart';
import '../../../services/tflite_service.dart';
import '../domain/models/inference_result.dart';
import '../presentation/pages/history_page.dart';

final inferenceProvider = StateNotifierProvider<InferenceNotifier, AsyncValue<List<InferenceResult>>>(
  (ref) => InferenceNotifier(
    ref.read(tfliteServiceProvider),
    ref.read(historyServiceProvider),
    ref,
  ),
);

class InferenceNotifier extends StateNotifier<AsyncValue<List<InferenceResult>>> {
  InferenceNotifier(this._service, this._historyService, this._ref) : super(const AsyncValue.data([]));

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

    print('📊 [InferenceNotifier] Bắt đầu inference');
    print('   📁 Ảnh: ${image.path}');
    print('   📏 Kích thước: ${image.lengthSync()} bytes');

    state = const AsyncValue.loading();
    try {
      // ✅ BƯỚC 2: Chạy inference
      print('🧠 [InferenceNotifier] Chạy model TFLite...');
      final results = await _service.run(image);
      
      print('✅ [InferenceNotifier] Inference xong!');
      print('   🏆 Top kết quả:');
      for (var i = 0; i < 3 && i < results.length; i++) {
        print('      [$i] ${results[i].label} - ${(results[i].confidence * 100).toStringAsFixed(1)}%');
      }

      state = AsyncValue.data(results);

      // ✅ BƯỚC 3: Lưu vào history
      if (results.isNotEmpty) {
        final topResult = results.first;
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
      }
    } catch (e, st) {
      print('❌ [InferenceNotifier] Lỗi inference: $e');
      print('   Stack: $st');
      state = AsyncValue.error(e, st);
    }
  }
}

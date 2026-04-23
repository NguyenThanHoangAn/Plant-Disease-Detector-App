import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import 'camera_capture_page.dart';

/// 📷 CameraPreviewPage - Xử lý chụp ảnh & preview
/// 
/// FLOW:
/// 1. Hiển thị 2 nút: Camera hoặc Gallery (KHÔNG auto-open)
/// 2. Người dùng chọn 1 trong 2 => mở picker
/// 3. Nhận ảnh => hiển thị preview
/// 4. 2 nút: "Chụp lại" (retake) hoặc "Dùng ảnh này" (confirm)
/// 5. Return File về HomePage để xử lý inference
class CameraPreviewPage extends StatefulWidget {
  const CameraPreviewPage({super.key});

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> with WidgetsBindingObserver {
  /// 📦 State variables
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasRecoveredLostData = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _recoverLostData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _recoverLostData();
    }
  }

  /// 📷 Chụp ảnh hoặc chọn từ gallery
  /// 
  /// - Không auto-open, chỉ khi user click
  /// - Handle permission denied, camera errors
  /// - Save ảnh & update UI
  Future<void> _pickImage(ImageSource source) async {
    // ⚠️ Prevent multiple concurrent picks
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      print('📷 [CameraPreviewPage._pickImage] Bắt đầu chọn ảnh từ ${source.name}');

      final XFile? xFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, // Compress để tránh memory issues
      );

      // ✅ Kiểm tra mounted & xFile
      if (!mounted) {
        print('⚠️ [CameraPreviewPage._pickImage] Widget unmounted');
        return;
      }

      if (xFile == null) {
        // User cancel
        print('⚠️ [CameraPreviewPage._pickImage] User cancel');
        setState(() => _isLoading = false);
        return;
      }

      final imageFile = File(xFile.path);

      // ✅ Kiểm tra file tồn tại
      if (!imageFile.existsSync()) {
        throw Exception('${l10n.imageNotFound}: ${imageFile.path}');
      }

      print('✅ [CameraPreviewPage._pickImage] Ảnh được chọn: ${imageFile.path}');
      print('   📏 Kích thước: ${imageFile.lengthSync()} bytes');

      // ✅ Update UI - hiển thị preview
      setState(() {
        _imageFile = imageFile;
        _isLoading = false;
      });

      // ✅ Show success snackbar
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.imageSelected)),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('❌ [CameraPreviewPage._pickImage] Lỗi: $e');

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _isLoading = false;
          _errorMessage = _getErrorMessage(e, l10n);
        });

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('${l10n.error}: $_errorMessage')),
              ],
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// ♻️ Khôi phục ảnh nếu Activity bị hệ thống hủy khi chụp ảnh
  Future<void> _recoverLostData() async {
    if (_hasRecoveredLostData || _imageFile != null) return;

    try {
      final response = await _picker.retrieveLostData();
      if (!mounted || response.isEmpty) return;

      if (response.file != null) {
        final recovered = File(response.file!.path);
        print('🔄 [CameraPreviewPage._recoverLostData] Phục hồi ảnh: ${recovered.path}');
        setState(() {
          _imageFile = recovered;
          _isLoading = false;
          _errorMessage = null;
          _hasRecoveredLostData = true;
        });
      } else if (response.exception != null) {
        print('⚠️ [CameraPreviewPage._recoverLostData] Lỗi phục hồi: ${response.exception}');
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = _getErrorMessage(response.exception!, l10n);
          _isLoading = false;
          _hasRecoveredLostData = true;
        });
      }
    } catch (e) {
      print('❌ [CameraPreviewPage._recoverLostData] Lỗi: $e');
    }
  }

  /// � Mở custom camera (CameraCapturePage)
  Future<void> _openCustomCamera() async {
    if (_isLoading) return;

    try {
      print('📷 [CameraPreviewPage._openCustomCamera] Mở camera tự tạo');
      
      final file = await Navigator.of(context).push<File?>(
        MaterialPageRoute(
          builder: (_) => const CameraCapturePage(),
        ),
      );

      if (!mounted) return;

      if (file != null) {
        print('✅ [CameraPreviewPage._openCustomCamera] Nhận ảnh từ CameraCapturePage: ${file.path}');
        setState(() {
          _imageFile = file;
          _isLoading = false;
          _errorMessage = null;
        });

        // Show success snackbar
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(l10n.imageCaptured)),
              ],
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: const Color(0xFF16A34A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        print('⚠️ [CameraPreviewPage._openCustomCamera] User cancel');
      }
    } catch (e) {
      print('❌ [CameraPreviewPage._openCustomCamera] Lỗi: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = '${l10n.error}: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// 🔄 Chụp/chọn ảnh lại
  void _retakePhoto() {
    setState(() {
      _imageFile = null;
      _errorMessage = null;
    });
    print('🔄 [CameraPreviewPage._retakePhoto] Reset ảnh');
  }

  /// ✅ Xác nhận & gửi ảnh về HomePage
  void _confirmPhoto() {
    if (_imageFile == null) return;

    print('✅ [CameraPreviewPage._confirmPhoto] Gửi ảnh: ${_imageFile!.path}');
    Navigator.of(context).pop(_imageFile);
  }

  /// 📊 Xử lý các loại lỗi khác nhau
  String _getErrorMessage(Object error, AppLocalizations l10n) {
    final message = error.toString().toLowerCase();

    if (message.contains('permission')) {
      return l10n.cameraAccessDenied;
    } else if (message.contains('camera')) {
      return l10n.cameraDeviceError;
    } else if (message.contains('memory') || message.contains('out of memory')) {
      return l10n.insufficientMemory;
    } else {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasImage = _imageFile != null;
    final canConfirm = hasImage && !_isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.takePicture),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🖼️ PREVIEW AREA - Hiển thị ảnh hoặc thông báo chưa chụp
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFF16A34A),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.loading,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 64,
                                  color: Color(0xFF9CA3AF),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.noImageSelected,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.selectImage,
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),

            // ⚠️ ERROR MESSAGE
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 📱 CAMERA / GALLERY BUTTONS - Chỉ hiển thị khi chưa có ảnh
            if (!hasImage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _openCustomCamera,
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(l10n.takePicture),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                          foregroundColor: theme.colorScheme.primary,
                          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library_outlined),
                        label: Text(l10n.selectFromGallery),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: theme.colorScheme.onSurface,
                            width: 2,
                          ),
                          foregroundColor: theme.colorScheme.onSurface,
                          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ✅/🔄 CONFIRM / RETAKE BUTTONS - Chỉ hiển thị khi đã có ảnh
            if (hasImage)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // 🔄 RETAKE BUTTON
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _retakePhoto,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retake),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(
                            color: Color(0xFF9CA3AF),
                            width: 2,
                          ),
                          foregroundColor: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // ✅ CONFIRM BUTTON
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: canConfirm ? _confirmPhoto : null,
                        icon: const Icon(Icons.check_circle),
                        label: Text(
                          l10n.useThisImage,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFD1D5DB),
                          disabledForegroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}


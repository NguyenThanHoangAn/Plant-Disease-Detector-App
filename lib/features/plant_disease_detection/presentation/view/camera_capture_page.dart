import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';

/// 📷 CameraCaptureePage - Camera trong app (không out ra ngoài)
/// 
/// FLOW:
/// 1. Khởi tạo camera controller
/// 2. Hiển thị camera preview trực tiếp trong app
/// 3. User chụp ảnh → Lưu file tạm
/// 4. Hiển thị preview ảnh vừa chụp
/// 5. Confirm → Return File về HomePage
class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isTakingPicture = false;
  File? _capturedImage;
  String? _errorMessage;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  /// 📷 Khởi tạo camera
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _errorMessage = 'Không tìm thấy camera trên thiết bị');
        return;
      }

      // Ưu tiên camera sau (back camera)
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.veryHigh, // Tăng resolution để tăng độ chính xác
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print('❌ [CameraCapturePage._initializeCamera] Lỗi: $e');
      if (mounted) {
        setState(() => _errorMessage = 'Lỗi khởi tạo camera: $e');
      }
    }
  }

  /// 📸 Chụp ảnh
  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);

    try {
      // Chụp ảnh với chất lượng cao nhất
      final xFile = await controller.takePicture();
      
      // Lưu vào thư mục tạm
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/camera_$timestamp.jpg';
      final file = File(filePath);
      
      // Đọc và crop ảnh theo khung hướng dẫn
      final bytes = await xFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      
      if (image != null) {
        // Crop ảnh theo tỉ lệ 75% ở giữa (khung hướng dẫn)
        final cropSize = (image.width * 0.75).toInt();
        final offsetX = ((image.width - cropSize) / 2).toInt();
        final offsetY = ((image.height - cropSize) / 2).toInt();
        
        image = img.copyCrop(image,
          x: offsetX,
          y: offsetY,
          width: cropSize,
          height: cropSize,
        );
        
        // Tăng độ sắc nét và contrast
        image = img.adjustColor(image,
          contrast: 1.2,
          brightness: 1.05,
        );
        
        // Lưu lại với chất lượng cao
        await file.writeAsBytes(img.encodeJpg(image, quality: 95));
      } else {
        // Nếu không crop được thì dùng ảnh gốc
        await file.writeAsBytes(bytes);
      }

      print('✅ [CameraCapturePage._takePicture] Đã chụp và crop: $filePath');

      if (mounted) {
        setState(() {
          _capturedImage = file;
          _isTakingPicture = false;
        });
      }
    } catch (e) {
      print('❌ [CameraCapturePage._takePicture] Lỗi: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _errorMessage = '${l10n.captureError}: $e';
          _isTakingPicture = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.captureError}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 🔄 Chụp lại
  void _retake() {
    setState(() => _capturedImage = null);
  }

  /// ✅ Xác nhận ảnh
  void _confirm() {
    if (_capturedImage != null) {
      Navigator.of(context).pop(_capturedImage);
    }
  }

  /// 🔙 Hủy và quay lại
  void _cancel() {
    Navigator.of(context).pop();
  }

  /// 💡 Toggle flash/torch
  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final newMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await controller.setFlashMode(newMode);
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      print('❌ [CameraCapturePage._toggleFlash] Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // ⚠️ Hiển thị lỗi
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _cancel,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      );
    }

    // 🖼️ Hiển thị ảnh đã chụp
    if (_capturedImage != null) {
      return _buildPreview();
    }

    // 📷 Hiển thị camera preview
    if (_isInitialized && _controller != null) {
      return _buildCameraPreview();
    }

    // ⏳ Loading
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Đang khởi tạo camera...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        // Camera preview - Full screen với đúng tỷ lệ
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller!.value.previewSize!.height,
              height: _controller!.value.previewSize!.width,
              child: CameraPreview(_controller!),
            ),
          ),
        ),

        // Overlay guide - Khung hướng dẫn chụp
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),

        // Vùng tối xung quanh khung
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tips - Hướng dẫn chụp
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Mẹo chụp ảnh chính xác:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '• Đặt lá trong khung trắng\n• Ánh sáng đủ, không mờ\n• Lá phẳng, rõ nét\n• Tránh bóng đổ',
                  style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ),

        // Header
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _cancel,
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
              const Text(
                'Chụp ảnh lá cà chua',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                ),
              ),
              IconButton(
                onPressed: _toggleFlash,
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? Colors.yellow : Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ),

        // Capture button
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _isTakingPicture ? null : _takePicture,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: _isTakingPicture 
                      ? Colors.grey 
                      : Colors.white.withOpacity(0.3),
                ),
                child: _isTakingPicture
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        // Image preview
        Center(
          child: Image.file(
            _capturedImage!,
            fit: BoxFit.contain,
          ),
        ),

        // Header
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '✓ Ảnh đã chụp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Action buttons
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Retake button
                _ActionButton(
                  icon: Icons.refresh,
                  label: 'Chụp lại',
                  onPressed: _retake,
                ),
                // Confirm button
                _ActionButton(
                  icon: Icons.check_circle,
                  label: 'Dùng ảnh này',
                  onPressed: _confirm,
                  isPrimary: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF16A34A) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

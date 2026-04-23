import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage>
    with WidgetsBindingObserver {
  static const double _guideSizeFactor = 0.75;
  static const double _cropPaddingFactor = 0.03;

  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isInitializing = false;
  bool _isDisposing = false;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;
  File? _capturedImage;
  String? _errorMessage;
  Offset? _focusIndicatorPosition;
  Timer? _focusIndicatorTimer;
  Size? _previewViewportSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeCamera();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusIndicatorTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;

    if (_isInitializing || _isDisposing) {
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (controller == null || !controller.value.isInitialized) {
        _initializeCamera();
      }
      return;
    }

    if (state == AppLifecycleState.inactive) {
      return;
    }

    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      if (controller != null && controller.value.isInitialized) {
        _disposeCameraController();
      }
    }
  }

  Future<void> _disposeCameraController() async {
    if (_isDisposing) {
      return;
    }

    _isDisposing = true;
    _focusIndicatorTimer?.cancel();

    final controller = _controller;
    _controller = null;

    if (mounted) {
      setState(() {
        _isInitialized = false;
        _isInitializing = false;
        _focusIndicatorPosition = null;
      });
    } else {
      _isInitialized = false;
      _isInitializing = false;
      _focusIndicatorPosition = null;
    }

    try {
      if (controller != null) {
        await controller.dispose();
      }
    } catch (e) {
      debugPrint('[CameraCapturePage._disposeCameraController] Error: $e');
    } finally {
      _isDisposing = false;
    }
  }

  Future<void> _initializeCamera() async {
    if (_isInitializing) {
      return;
    }

    while (_isDisposing) {
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }

    try {
      if (!mounted) {
        return;
      }

      final l10n = AppLocalizations.of(context)!;

      if (mounted) {
        setState(() {
          _isInitializing = true;
          _isInitialized = false;
          _errorMessage = null;
        });
      } else {
        _isInitializing = true;
        _isInitialized = false;
        _errorMessage = null;
      }

      final cameras = await availableCameras();
      _cameras = cameras;

      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _errorMessage = l10n.cameraNotFoundOnDevice;
          });
        }
        return;
      }

      if (_controller != null) {
        await _disposeCameraController();
      }

      final camera = _cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      final controller = await _createCameraController(camera);
      _controller = controller;

      await _configureCameraForAccuracy(controller);

      if (!mounted || _controller != controller) {
        await controller.dispose();
        return;
      }

      setState(() {
        _isInitialized = true;
        _errorMessage = null;
      });
    } catch (e) {
      final friendlyMessage = mounted
          ? _buildFriendlyCameraErrorMessage(
              error: e,
              l10n: AppLocalizations.of(context)!,
            )
          : 'Camera error';

      if (mounted) {
        setState(() {
          _errorMessage = friendlyMessage;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      } else {
        _isInitializing = false;
      }
    }
  }

  String _buildFriendlyCameraErrorMessage({
    required Object error,
    required AppLocalizations l10n,
  }) {
    if (error is CameraException) {
      switch (error.code) {
        case 'CameraAccessDenied':
        case 'CameraAccessDeniedWithoutPrompt':
        case 'CameraAccessRestricted':
          return l10n.cameraAccessDenied;
        default:
          return l10n.cameraDeviceError;
      }
    }

    final normalized = error.toString().toLowerCase();
    if (normalized.contains('illegalstateexception') ||
        normalized.contains('fluttersurfaceproducer') ||
        normalized.contains('releasefluttersurfacetexture')) {
      return l10n.cameraDeviceError;
    }

    return l10n.cameraDeviceError;
  }

  Future<CameraController> _createCameraController(
    CameraDescription camera,
  ) async {
    final controller = CameraController(
      camera,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await controller.initialize();
      return controller;
    } catch (error) {
      await controller.dispose();
      rethrow;
    }
  }

  Future<void> _configureCameraForAccuracy(
    CameraController controller,
  ) async {
    try {
      await controller.setFlashMode(FlashMode.off);
      _isFlashOn = false;
    } catch (_) {}

    try {
      await controller.setFocusMode(FocusMode.auto);
    } catch (_) {}

    try {
      await controller.setExposureMode(ExposureMode.auto);
    } catch (_) {}

    await _applyMeteringPoint(
      controller: controller,
      point: const Offset(0.5, 0.5),
    );
  }

  Future<void> _applyMeteringPoint({
    CameraController? controller,
    required Offset point,
  }) async {
    final activeController = controller ?? _controller;
    if (activeController == null || !activeController.value.isInitialized) {
      return;
    }

    final normalizedPoint = Offset(
      point.dx.clamp(0.0, 1.0),
      point.dy.clamp(0.0, 1.0),
    );

    try {
      await Future.wait([
        activeController.setFocusPoint(normalizedPoint),
        activeController.setExposurePoint(normalizedPoint),
      ]);
    } catch (_) {}
  }

  Future<void> _handlePreviewTap(
    TapDownDetails details,
    BoxConstraints constraints,
  ) async {
    if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
      return;
    }

    final localPosition = details.localPosition;
    final normalizedPoint = Offset(
      localPosition.dx / constraints.maxWidth,
      localPosition.dy / constraints.maxHeight,
    );

    await _applyMeteringPoint(point: normalizedPoint);

    _focusIndicatorTimer?.cancel();
    if (mounted) {
      setState(() {
        _focusIndicatorPosition = localPosition;
      });
    }

    _focusIndicatorTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _focusIndicatorPosition = null;
        });
      }
    });
  }

  Rect? _buildCropRectForGuide({
    required Size screenSize,
    required Size previewSize,
    required Size imageSize,
  }) {
    if (screenSize.width <= 0 ||
        screenSize.height <= 0 ||
        previewSize.width <= 0 ||
        previewSize.height <= 0 ||
        imageSize.width <= 0 ||
        imageSize.height <= 0) {
      return null;
    }

    final previewDisplaySize = Size(previewSize.height, previewSize.width);
    final scale = math.max(
      screenSize.width / previewDisplaySize.width,
      screenSize.height / previewDisplaySize.height,
    );

    if (scale <= 0) {
      return null;
    }

    final scaledPreviewWidth = previewDisplaySize.width * scale;
    final scaledPreviewHeight = previewDisplaySize.height * scale;
    final horizontalCrop = (scaledPreviewWidth - screenSize.width) / 2;
    final verticalCrop = (scaledPreviewHeight - screenSize.height) / 2;

    final guideSize = screenSize.width * _guideSizeFactor;
    final guideLeft = (screenSize.width - guideSize) / 2;
    final guideTop = (screenSize.height - guideSize) / 2;

    final previewLeft = (guideLeft + horizontalCrop) / scale;
    final previewTop = (guideTop + verticalCrop) / scale;
    final previewSide = guideSize / scale;

    final left = (previewLeft / previewDisplaySize.width) * imageSize.width;
    final top = (previewTop / previewDisplaySize.height) * imageSize.height;
    final width = (previewSide / previewDisplaySize.width) * imageSize.width;
    final height = (previewSide / previewDisplaySize.height) * imageSize.height;
    final side = math.min(width, height);

    if (side <= 0) {
      return null;
    }

    final paddedSide = side * (1 + (_cropPaddingFactor * 2));
    final paddedLeft = left - (side * _cropPaddingFactor);
    final paddedTop = top - (side * _cropPaddingFactor);

    final safeLeft = paddedLeft.clamp(0.0, imageSize.width - 1);
    final safeTop = paddedTop.clamp(0.0, imageSize.height - 1);
    final safeWidth = paddedSide.clamp(1.0, imageSize.width - safeLeft);
    final safeHeight = paddedSide.clamp(1.0, imageSize.height - safeTop);
    final safeSide = math.min(safeWidth, safeHeight);

    return Rect.fromLTWH(safeLeft, safeTop, safeSide, safeSide);
  }

  Size _getSafeViewportSize() {
    final mediaSize = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final safeHeight = math.max(
      1.0,
      mediaSize.height - padding.top - padding.bottom,
    );
    return Size(mediaSize.width, safeHeight);
  }

  Future<File> _processCapturedImage({
    required XFile xFile,
    required CameraController controller,
  }) async {
    final directory = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory.path}/camera_$timestamp.jpg';
    final file = File(filePath);

    final bytes = await xFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      await file.writeAsBytes(bytes);
      return file;
    }

    var processedImage = img.bakeOrientation(decodedImage);
    final previewSize = controller.value.previewSize;

    if (previewSize != null && mounted) {
      final cropRect = _buildCropRectForGuide(
        screenSize: _previewViewportSize ?? _getSafeViewportSize(),
        previewSize: previewSize,
        imageSize: Size(
          processedImage.width.toDouble(),
          processedImage.height.toDouble(),
        ),
      );

      if (cropRect != null) {
        processedImage = img.copyCrop(
          processedImage,
          x: cropRect.left.round(),
          y: cropRect.top.round(),
          width: cropRect.width.round(),
          height: cropRect.height.round(),
        );
      }
    }

    await file.writeAsBytes(
      img.encodeJpg(processedImage, quality: 100),
    );
    return file;
  }

  Future<void> _takePicture() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        controller.value.isTakingPicture ||
        _isTakingPicture) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
      _focusIndicatorPosition = null;
    });

    try {
      final xFile = await controller.takePicture();
      final file = await _processCapturedImage(
        xFile: xFile,
        controller: controller,
      );

      if (mounted) {
        setState(() {
          _capturedImage = file;
          _isTakingPicture = false;
        });
      }
    } catch (e) {
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

  void _retake() {
    setState(() {
      _capturedImage = null;
    });
  }

  void _confirm() {
    if (_capturedImage != null) {
      Navigator.of(context).pop(_capturedImage);
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    try {
      final newMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await controller.setFlashMode(newMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (_) {}
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
    if (_capturedImage != null) {
      return _buildPreview();
    }

    if (_errorMessage != null && !_isInitializing) {
      return _buildErrorState();
    }

    if (_isInitialized && _controller != null) {
      return _buildCameraPreview();
    }

    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            l10n.cameraInitializing,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white70,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? l10n.cameraDeviceError,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: Text(l10n.retryWithBetterImage),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    final controller = _controller;
    final l10n = AppLocalizations.of(context)!;

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _previewViewportSize = Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final guideSize = constraints.maxWidth * _guideSizeFactor;

        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) => _handlePreviewTap(details, constraints),
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: previewSize.height,
                    height: previewSize.width,
                    child: CameraPreview(controller),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: guideSize,
                height: guideSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.5),
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
                      width: guideSize,
                      height: guideSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_focusIndicatorPosition != null)
              Positioned(
                left: _focusIndicatorPosition!.dx - 28,
                top: _focusIndicatorPosition!.dy - 28,
                child: IgnorePointer(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amberAccent, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _cancel,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  Text(
                    l10n.cameraCaptureLeafTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 8, color: Colors.black),
                      ],
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
            Positioned(
              top: 72,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  l10n.cameraTipsBody,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
            ),
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
                          : Colors.white.withValues(alpha: 0.3),
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
      },
    );
  }

  Widget _buildPreview() {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Center(
          child: Image.file(
            _capturedImage!,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.imageCaptured,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.refresh,
                    label: l10n.retake,
                    onPressed: _retake,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.check_circle,
                    label: l10n.useThisImage,
                    onPressed: _confirm,
                    isPrimary: true,
                  ),
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
      label: Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? const Color(0xFF16A34A) : Colors.white,
        foregroundColor: isPrimary ? Colors.white : Colors.black87,
        minimumSize: const Size(double.infinity, 52),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/inference_result.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/verification_result.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/presentation/viewmodels/inference_view_model.dart';

import '../widgets/common/language_switcher.dart';
import 'camera_capture_page.dart';
import 'camera_preview_page.dart';
import 'history_page.dart';
import 'info_page.dart';
import 'result_detail_page.dart';
import 'supported_plants_page.dart';

class DeepLearningHomePage extends ConsumerStatefulWidget {
  const DeepLearningHomePage({super.key});

  @override
  ConsumerState<DeepLearningHomePage> createState() =>
      _DeepLearningHomePageState();
}

class _DeepLearningHomePageState extends ConsumerState<DeepLearningHomePage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  File? _selectedImage;
  int _currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {}
  }

  Future<void> _openInAppCamera() async {
    try {
      final file = await Navigator.of(context).push<File?>(
        MaterialPageRoute(
          builder: (_) => const CameraCapturePage(),
        ),
      );

      if (file != null && mounted) {
        setState(() {
          _selectedImage = file;
        });

        await ref.read(inferenceProvider.notifier).runInference(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openCameraPreview() async {
    try {
      final file = await Navigator.of(context).push<File?>(
        MaterialPageRoute(
          builder: (_) => const CameraPreviewPage(),
        ),
      );

      if (file != null && mounted) {
        setState(() {
          _selectedImage = file;
        });

        await ref.read(inferenceProvider.notifier).runInference(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showVerificationQualityDialog(
    BuildContext context,
    VerificationResult result,
    AppLocalizations l10n,
  ) async {
    String title;
    String message;
    IconData icon;
    Color iconColor;

    if (result.isPassed && result.isWarning) {
      title = l10n.poorImageQuality;
      message = l10n.poorImageQualityDesc;
      icon = Icons.blur_on;
      iconColor = Colors.orange;
    } else if (result.isPassed) {
      title = 'Đánh giá chất lượng ảnh';
      message = 'Ảnh đã được kiểm tra chất lượng và phân tích thành công.';
      icon = Icons.verified;
      iconColor = Colors.green;
    } else {
      switch (result.error) {
        case VerificationError.poorQuality:
          title = l10n.poorImageQuality;
          message = l10n.poorImageQualityDesc;
          icon = Icons.blur_on;
          iconColor = Colors.orange;
          break;
        case VerificationError.lowConfidence:
          title = l10n.poorImageQuality;
          message = l10n.poorImageQualityDesc;
          icon = Icons.blur_on;
          iconColor = Colors.orange;
          break;
        case VerificationError.outOfScope:
          title = l10n.imageOutOfScope;
          message = result.message ?? l10n.imageOutOfScopeDesc;
          icon = Icons.cancel;
          iconColor = Colors.red;
          break;
        default:
          title = l10n.verificationFailed;
          message = result.message ?? l10n.errorOccurred;
          icon = Icons.warning;
          iconColor = Colors.red;
      }
    }

    final qualityText = result.imageQualityScore != null
        ? '${result.imageQualityScore!.toStringAsFixed(0)}/100'
        : '--/100';

    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.replaceAll('\\n', '\n'),
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.assessment, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${l10n.imageQualityScore}: $qualityText',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Gợi ý: chụp đủ sáng, giữ máy chắc tay, lấy nét lá bệnh và nền đơn giản.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final allowContinue = result.isPassed && !result.isWarning;
              Navigator.of(context).pop(allowContinue);
            },
            child: Text(
              result.isPassed && !result.isWarning
                  ? 'Tiếp tục'
                  : l10n.retryWithBetterImage,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldContinue ?? false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final inferenceState = ref.watch(inferenceProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    ref.listen(inferenceProvider, (previous, next) {
      next.when(
        data: (verificationResult) {
          if (verificationResult == null) return;

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;

            final canNavigateDirectly =
                verificationResult.isPassed && !verificationResult.isWarning;

            bool shouldNavigate = canNavigateDirectly;

            // Ảnh đạt chuẩn và pass hoàn toàn -> đi thẳng vào kết quả, không hiện popup.
            if (!canNavigateDirectly) {
              shouldNavigate = await _showVerificationQualityDialog(
                context,
                verificationResult,
                l10n,
              );
              if (!mounted) return;
            }

            if (shouldNavigate &&
                verificationResult.isPassed &&
                verificationResult.predictions.isNotEmpty &&
                _selectedImage != null) {
              final top1 = verificationResult.predictions.first;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ResultDetailPage(result: top1, image: _selectedImage),
                ),
              );
            } else {
              setState(() {
                _selectedImage = null;
              });
            }
          });
        },
        loading: () {},
        error: (error, stackTrace) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.analysisError}: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(theme, inferenceState),
          const TomatoHistoryView(),
          const SupportedPlantsPage(),
          const TomatoInfoView(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        theme: theme,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildHomeTab(
      ThemeData theme, AsyncValue<VerificationResult?> inferenceState) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(theme: theme),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ActionCard(
                            theme: theme,
                            onCamera: _openInAppCamera,
                            onGallery: _openCameraPreview,
                          ),
                          const SizedBox(height: 32),
                          _KeyFeaturesSection(theme: theme),
                          const SizedBox(height: 24),
                          _SupportedCropsSection(
                            theme: theme,
                            onOpenSupportedPlants: () {
                              setState(() => _currentIndex = 2);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _Header extends StatelessWidget {
  const _Header({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                l10n.aiPlantScanner,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const ThemeToggleButton(),
              const SizedBox(width: 8),
              const LanguageToggleButton(),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            l10n.scanAnyPlantLeaf,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.aiIdentifyDescription,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.theme,
    required this.onCamera,
    required this.onGallery,
  });

  final ThemeData theme;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Take Photo Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    l10n.takePicture,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Upload Image Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onGallery,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: theme.colorScheme.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.upload, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    l10n.selectFromGallery,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyFeaturesSection extends StatelessWidget {
  const _KeyFeaturesSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.keyFeatures,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
          children: [
            _FeatureCard(
              icon: Icons.spa_outlined,
              title: l10n.autoPlantRecognition,
              subtitle: l10n.autoPlantRecognitionDesc,
              color: theme.colorScheme.primary,
            ),
            _FeatureCard(
              icon: Icons.auto_fix_high,
              title: l10n.multiDiseaseClassification,
              subtitle: l10n.multiDiseaseClassificationDesc,
              color: theme.colorScheme.primary,
            ),
            _FeatureCard(
              icon: Icons.bolt_outlined,
              title: l10n.instantResults,
              subtitle: l10n.instantResultsDesc,
              color: theme.colorScheme.primary,
            ),
            _FeatureCard(
              icon: Icons.speed,
              title: l10n.offlineMode,
              subtitle: l10n.offlineModeDesc,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.5,
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportedCropsSection extends StatelessWidget {
  const _SupportedCropsSection({
    required this.theme,
    required this.onOpenSupportedPlants,
  });

  final ThemeData theme;
  final VoidCallback onOpenSupportedPlants;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.supportedCrops,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: onOpenSupportedPlants,
              child: Text(
                '${l10n.viewDetails} →',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _CropChip(nameKey: 'tomato', onTap: onOpenSupportedPlants),
            _CropChip(nameKey: 'grape', onTap: onOpenSupportedPlants),
            _CropChip(nameKey: 'potato', onTap: onOpenSupportedPlants),
            _CropChip(nameKey: 'apple', onTap: onOpenSupportedPlants),
            _CropChip(nameKey: 'corn', onTap: onOpenSupportedPlants),
          ],
        ),
      ],
    );
  }
}

class _CropChip extends StatelessWidget {
  const _CropChip({required this.nameKey, this.customText, this.onTap});

  final String nameKey;
  final String? customText;
  final VoidCallback? onTap;

  String _getLocalizedName(AppLocalizations l10n) {
    switch (nameKey) {
      case 'tomato':
        return l10n.tomato;
      case 'grape':
        return l10n.grape;
      case 'potato':
        return l10n.potato;
      case 'apple':
        return l10n.apple;
      case 'corn':
        return l10n.corn;
      case 'rice':
        return l10n.rice;
      case 'bellPepper':
        return l10n.bellPepper;
      case 'cucumber':
        return l10n.cucumber;
      case 'soybean':
        return l10n.soybean;
      case 'chili':
        return l10n.chili;
      case 'more':
        return l10n.moreText;
      default:
        return nameKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final displayText = customText != null
        ? '$customText ${_getLocalizedName(l10n)}'
        : _getLocalizedName(l10n);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.35)),
        ),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _PreviewArea extends StatelessWidget {
  const _PreviewArea({
    required this.theme,
    required this.selectedImage,
    required this.onClear,
  });

  final ThemeData theme;
  final File? selectedImage;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: selectedImage == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined,
                    color: theme.colorScheme.primary, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'No image selected',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ],
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                ),
                if (onClear != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.55),
                      radius: 16,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 16,
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: onClear,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Capture leaf with camera',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF4B5563)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF1F2937),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

class _ResultsSection extends StatelessWidget {
  const _ResultsSection({
    required this.theme,
    required this.inferenceState,
    required this.selectedImage,
  });

  final ThemeData theme;
  final AsyncValue<List<InferenceResult>> inferenceState;
  final File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          inferenceState.when(
            data: (results) => results.isEmpty
                ? const Text(
                    'No results yet. Tap Analyze to start.',
                    style: TextStyle(color: Color(0xFF6B7280)),
                  )
                : Column(
                    children: results
                        .map(
                          (r) => _ResultCard(
                            result: r,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ResultDetailPage(
                                    result: r,
                                    image: selectedImage,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
            error: (err, _) => Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error: $err',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              ],
            ),
            loading: () => const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                SizedBox(width: 12),
                Text('Analyzing...'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  const _HowItWorksCard({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HowItWorksHeader(),
          SizedBox(height: 14),
          _StepItem(
            index: 1,
            title: 'Capture Leaf Image',
            description:
                'Take a clear photo of the tomato leaf or upload from your gallery',
          ),
          SizedBox(height: 12),
          _StepItem(
            index: 2,
            title: 'CNN Analysis',
            description:
                'Our deep learning model analyzes the image with high accuracy',
          ),
          SizedBox(height: 12),
          _StepItem(
            index: 3,
            title: 'Disease Classification',
            description:
              'Get instant results with disease name and guidance',
          ),
        ],
      ),
    );
  }
}

class _AnalyzingOverlay extends StatelessWidget {
  const _AnalyzingOverlay({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: false,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: 1,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.30),
                Colors.black.withOpacity(0.45),
              ],
            ),
          ),
          child: Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withOpacity(0.12),
                        ),
                        child: Icon(Icons.auto_graph_rounded,
                            color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Analyzing leaf...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Our CNN model is running. This may take a few seconds.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _ShimmerBar(),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Analyzing with TensorFlow Lite...',
                        style: TextStyle(
                            color: Color(0xFF0F172A),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerBar extends StatefulWidget {
  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final gradient = LinearGradient(
            begin: Alignment(-1 + 2 * _controller.value, 0),
            end: Alignment(1 + 2 * _controller.value, 0),
            colors: const [
              Color(0xFFE5E7EB),
              Color(0xFFD1FAE5),
              Color(0xFFE5E7EB),
            ],
          );
          return Container(
            height: 10,
            decoration: BoxDecoration(gradient: gradient),
          );
        },
      ),
    );
  }
}

class _HowItWorksHeader extends StatelessWidget {
  const _HowItWorksHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.search_rounded, color: Color(0xFF16A34A)),
        SizedBox(width: 8),
        Text(
          'How It Works',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: const Color(0xFFE8F5E9),
          child: Text(
            '$index',
            style: const TextStyle(
              color: Color(0xFF16A34A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.theme,
    required this.currentIndex,
    required this.onTap,
  });

  final ThemeData theme;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_rounded,
              label: l10n.home,
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.history_rounded,
              label: l10n.history,
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.eco_rounded,
              label: l10n.supportedPlants,
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.info_outline_rounded,
              label: l10n.info,
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result, this.onTap});

  final InferenceResult result;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHealthy = result.label.toLowerCase().contains('healthy');
    final accentColor = isHealthy ? const Color(0xFF16A34A) : const Color(0xFFEA580C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isHealthy
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isHealthy ? 'Cây khỏe' : 'Có dấu hiệu bệnh',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

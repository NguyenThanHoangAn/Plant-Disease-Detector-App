import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/tflite_service.dart';

final labelCountProvider = FutureProvider<int>((ref) async {
  final service = ref.read(tfliteServiceProvider);
  return await service.getLabelCount();
});

class TomatoInfoView extends ConsumerWidget {
  const TomatoInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelCountAsync = ref.watch(labelCountProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: const Color(0xFFF9FAFB),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Header(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mission Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.emoji_objects_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.ourMission,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.ourMissionDesc,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.howAiWorks,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.howAiWorksDesc,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.query_stats,
                      title: l10n.convolutionalNeuralNetworks,
                      description: l10n.convolutionalNeuralNetworksDesc,
                      color: const Color(0xFF3B82F6),
                    ),
                    const SizedBox(height: 12),
                    _FeatureCard(
                      icon: Icons.remove_red_eye_outlined,
                      title: l10n.computerVision,
                      description: l10n.computerVisionDesc,
                      color: const Color(0xFF8B5CF6),
                    ),
                    const SizedBox(height: 12),
                    _FeatureCard(
                      icon: Icons.trending_up,
                      title: l10n.deepLearningTraining,
                      description: l10n.deepLearningTrainingDesc,
                      color: const Color(0xFFEC4899),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.technicalFeatures,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Column(
                        children: [
                          _TechSpecRow(
                            label: l10n.cnnArchitecture,
                            description: l10n.cnnArchitectureDesc,
                          ),
                          const Divider(height: 24),
                          _TechSpecRow(
                            label: l10n.multiCropSupport,
                            description: l10n.multiCropSupportDesc,
                          ),
                          const Divider(height: 24),
                          _TechSpecRow(
                            label: l10n.highAccuracy,
                            description: l10n.highAccuracyDesc,
                          ),
                          const Divider(height: 24),
                          _TechSpecRow(
                            label: l10n.realTimeProcessing,
                            description: l10n.realTimeProcessingDesc,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.benefitsOfAi,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _BenefitCard(
                      icon: Icons.speed,
                      title: l10n.earlyDetection,
                      subtitle: l10n.earlyDetectionDesc,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.attach_money,
                      title: l10n.costEffective,
                      subtitle: l10n.costEffectiveDesc,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.eco,
                      title: l10n.ecoFriendly,
                      subtitle: l10n.ecoFriendlyDesc,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _BenefitCard(
                      icon: Icons.lock,
                      title: l10n.dataPrivacy,
                      subtitle: l10n.dataPrivacyDesc,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      ),
                    ),
                    _BenefitCard(
                      icon: Icons.insights,
                      title: l10n.dataDriven,
                      subtitle: l10n.dataDrivenDesc,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.whoCanUseOurApp,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _UserTypeCard(
                      icon: Icons.agriculture,
                      title: l10n.farmersAndGrowers,
                      description: l10n.farmersAndGrowersDesc,
                    ),
                    const SizedBox(height: 12),
                    _UserTypeCard(
                      icon: Icons.school,
                      title: l10n.studentsAndResearchers,
                      description: l10n.studentsAndResearchersDesc,
                    ),
                    const SizedBox(height: 12),
                    _UserTypeCard(
                      icon: Icons.spa,
                      title: l10n.homeGardeners,
                      description: l10n.homeGardenersDesc,
                    ),
                    const SizedBox(height: 24),
                    // Support Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.support_agent,
                                  color: Color(0xFF3B82F6),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                l10n.supportInformation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.supportInformationDesc,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E40AF),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF22C55E),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                l10n.about,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.aiAndSmartAgriculture,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
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
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CnnCard extends StatelessWidget {
  const _CnnCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _InfoCard(
      icon: Icons.memory_outlined,
      iconBg: const Color(0xFFEDE9FE),
      iconColor: const Color(0xFF7C3AED),
      title: l10n.cnnAndDeepLearning,
      body: l10n.cnnAndDeepLearningDesc,
    );
  }
}

class _PerformanceCard extends ConsumerWidget {
  const _PerformanceCard({required this.labelCountAsync});

  final AsyncValue<int> labelCountAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.modelPerformance,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          _metricRow(l10n.accuracy, '~97%', Colors.green, l10n),
          const SizedBox(height: 8),
          _metricRow(l10n.trainingDataset, '10,000+ ${l10n.images}', Colors.blue, l10n),
          const SizedBox(height: 8),
          labelCountAsync.when(
            data: (count) => _metricRow(l10n.diseaseClasses, '$count ${l10n.types}', Colors.purple, l10n),
            loading: () => _metricRow(l10n.diseaseClasses, '${l10n.loading}', Colors.purple, l10n),
            error: (_, __) => _metricRow(l10n.diseaseClasses, 'N/A', Colors.purple, l10n),
          ),
        ],
      ),
    );
  }

  static Widget _metricRow(String label, String value, Color color, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(999),
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: label == 'Accuracy' ? 0.97 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResearchCard extends StatelessWidget {
  const _ResearchCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _InfoCard(
      icon: Icons.school_outlined,
      iconBg: const Color(0xFFFFEDD5),
      iconColor: const Color(0xFFEA580C),
      title: l10n.academicFoundation,
      body: l10n.academicFoundationDesc,
    );
  }
}

class _TechCard extends StatelessWidget {
  const _TechCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = [
      ('TensorFlow', l10n.deepLearning),
      ('CNN', l10n.imageAnalysis),
      ('Flutter', l10n.mobileUI),
      ('Python', l10n.modelTraining),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.technologies,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips
                .map(
                  (c) => Container(
                    width: 140,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEEF2FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          c.$2,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4338CA),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _VersionCard extends StatelessWidget {
  const _VersionCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE5E7EB), Color(0xFFF3F4F6)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Column(
        children: [
          Text(
            '${l10n.version} 1.0.0',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.released} December 2025',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.developedFor,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TechSpecRow extends StatelessWidget {
  const _TechSpecRow({
    required this.label,
    required this.description,
  });

  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: Color(0xFF22C55E),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTypeCard extends StatelessWidget {
  const _UserTypeCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF22C55E), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/disease_data.dart';

/// Trang hiển thị thông tin chi tiết về một bệnh cụ thể
class DiseaseInfoPage extends StatelessWidget {
  const DiseaseInfoPage({
    super.key,
    required this.diseaseLabel,
  });

  final String diseaseLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    final plantName = DiseaseDataRepository.getPlantName(diseaseLabel, locale);
    final diseaseName = DiseaseDataRepository.getDiseaseName(diseaseLabel, locale);
    final description = DiseaseDataRepository.getDescription(diseaseLabel, locale);
    final symptoms = DiseaseDataRepository.getSymptoms(diseaseLabel, locale);
    final causes = DiseaseDataRepository.getCauses(diseaseLabel, locale);
    final preventionTips = DiseaseDataRepository.getPreventionTips(diseaseLabel, locale);
    final organicTreatments = DiseaseDataRepository.getOrganicTreatments(diseaseLabel, locale);
    final chemicalTreatments = DiseaseDataRepository.getChemicalTreatments(diseaseLabel, locale);
    final culturalPractices = DiseaseDataRepository.getCulturalPractices(diseaseLabel, locale);
    
    final isHealthy = diseaseLabel.toLowerCase().contains('healthy');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(diseaseName),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isHealthy
                        ? [const Color(0xFF22C55E), const Color(0xFF16A34A)]
                        : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isHealthy 
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444)).withOpacity(0.3),
                      blurRadius: 12,
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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isHealthy ? Icons.check_circle : Icons.warning,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plantName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                diseaseName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (!isHealthy) ...[
                const SizedBox(height: 24),

                // Symptoms
                if (symptoms.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.coronavirus,
                    title: l10n.symptoms,
                    iconColor: const Color(0xFFEF4444),
                    items: symptoms,
                  ),

                const SizedBox(height: 16),

                // Causes
                if (causes.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.science,
                    title: l10n.causes,
                    iconColor: const Color(0xFF8B5CF6),
                    items: causes,
                  ),

                const SizedBox(height: 16),

                // Prevention
                if (preventionTips.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.shield,
                    title: l10n.prevention,
                    iconColor: const Color(0xFF22C55E),
                    items: preventionTips,
                  ),

                const SizedBox(height: 16),

                // Organic Treatments
                if (organicTreatments.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.eco,
                    title: l10n.organicTreatment,
                    iconColor: const Color(0xFF10B981),
                    items: organicTreatments,
                  ),

                const SizedBox(height: 16),

                // Chemical Treatments
                if (chemicalTreatments.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.medication,
                    title: l10n.chemicalTreatment,
                    iconColor: const Color(0xFFF59E0B),
                    items: chemicalTreatments,
                  ),

                const SizedBox(height: 16),

                // Cultural Practices
                if (culturalPractices.isNotEmpty)
                  _buildSection(
                    context: context,
                    icon: Icons.agriculture,
                    title: l10n.culturalPractices,
                    iconColor: const Color(0xFF06B6D4),
                    items: culturalPractices,
                  ),
              ] else ...[
                const SizedBox(height: 24),
                
                // Healthy plant tips
                _buildSection(
                  context: context,
                  icon: Icons.tips_and_updates,
                  title: l10n.maintenanceTips,
                  iconColor: const Color(0xFF22C55E),
                  items: preventionTips.isNotEmpty 
                      ? preventionTips 
                      : [
                          locale == 'vi'
                              ? 'Duy trì chế độ tưới nước đều đặn'
                              : 'Maintain regular watering schedule',
                          locale == 'vi'
                              ? 'Bón phân cân đối định kỳ'
                              : 'Apply balanced fertilizer regularly',
                          locale == 'vi'
                              ? 'Theo dõi sâu bệnh thường xuyên'
                              : 'Monitor for pests regularly',
                          locale == 'vi'
                              ? 'Đảm bảo ánh sáng và thông khí tốt'
                              : 'Ensure good light and ventilation',
                        ],
                ),
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color iconColor,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _Bullet(text: item)),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

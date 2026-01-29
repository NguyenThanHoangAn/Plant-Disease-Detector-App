import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/disease_data.dart';
import '../../domain/models/inference_result.dart';

class DiseaseDetailPage extends StatelessWidget {
  const DiseaseDetailPage({
    super.key,
    required this.result,
    this.image,
  });

  final InferenceResult result;
  final File? image;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final diseaseName = DiseaseDataRepository.getDiseaseName(result.label, locale);
    final isDiseased = !result.label.toLowerCase().contains('healthy');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(l10n.diseaseDetails),
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
              // Header with image
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    image!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              if (image != null) const SizedBox(height: 16),

              // Disease Name
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
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
                            color: isDiseased
                                ? const Color(0xFFFFEDD5)
                                : const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isDiseased ? Icons.warning_amber : Icons.check_circle,
                            color: isDiseased
                                ? const Color(0xFFEA580C)
                                : const Color(0xFF16A34A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.identifiedDisease,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Symptoms
              _buildSection(
                context: context,
                icon: Icons.description_outlined,
                title: l10n.symptoms,
                iconColor: const Color(0xFFEF4444),
                items: DiseaseDataRepository.getSymptoms(result.label, locale),
              ),

              const SizedBox(height: 16),

              // Possible Causes
              _buildSection(
                context: context,
                icon: Icons.info_outline,
                title: l10n.possibleCauses,
                iconColor: const Color(0xFFF59E0B),
                items: DiseaseDataRepository.getCauses(result.label, locale),
              ),

              const SizedBox(height: 16),

              // Prevention Tips
              _buildSection(
                context: context,
                icon: Icons.shield_outlined,
                title: l10n.preventionTips,
                iconColor: const Color(0xFF3B82F6),
                items: DiseaseDataRepository.getPreventionTips(result.label, locale),
              ),

              const SizedBox(height: 16),

              // Basic Treatment Suggestions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0F000000),
                      blurRadius: 10,
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
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.healing,
                            color: Color(0xFF16A34A),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.basicTreatmentSuggestions,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Organic Options
                    Text(
                      l10n.organicOptions,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...DiseaseDataRepository.getOrganicTreatments(result.label, locale).map((item) => _Bullet(text: item)),
                    
                    const SizedBox(height: 16),

                    // Chemical Options
                    Text(
                      l10n.chemicalOptions,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...DiseaseDataRepository.getChemicalTreatments(result.label, locale).map((item) => _Bullet(text: item)),
                    
                    const SizedBox(height: 16),

                    // Cultural Practices
                    Text(
                      l10n.culturalPractices,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...DiseaseDataRepository.getCulturalPractices(result.label, locale).map((item) => _Bullet(text: item)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Important Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE047)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFCA8A04),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.importantDisclaimer,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.importantDisclaimerDesc,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF92400E),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

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
            color: Color(0x0F000000),
            blurRadius: 10,
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
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 6,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

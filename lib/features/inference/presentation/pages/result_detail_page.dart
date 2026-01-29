import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/disease_data.dart';
import '../../domain/models/inference_result.dart';
import 'disease_detail_page.dart';

// Helper function to get localized plant name
String _getPlantName(String label, String locale) {
  return DiseaseDataRepository.getPlantName(label, locale);
}

// Helper function to get localized disease name
String _getDiseaseName(String label, String locale) {
  return DiseaseDataRepository.getDiseaseName(label, locale);
}


String _getDiseaseDescription(String label, String locale) {
  final plantName = _getPlantName(label, locale);
  final description = DiseaseDataRepository.getDescription(label, locale);
  
  // For healthy plants, prepend plant name
  if (label.toLowerCase().contains('healthy')) {
    return locale == 'vi' 
        ? 'Cây $plantName $description'
        : 'The $plantName $description';
  }
  
  return description;
}

List<String> _getRecommendedActions(String label) {
  final normalizedLabel = label.toLowerCase().replaceAll('_', ' ').trim();
  
  if (normalizedLabel.contains('healthy')) {
    return [
      'Continue regular watering and fertilization schedule.',
      'Monitor plants weekly for any signs of disease.',
      'Maintain good air circulation around plants.',
      'Practice crop rotation for future plantings.',
    ];
  } else if (normalizedLabel.contains('early blight')) {
    return [
      'Remove and destroy infected leaves immediately.',
      'Apply copper-based fungicides or chlorothalonil.',
      'Mulch around plants to prevent soil splash.',
      'Water at the base of plants, avoid wetting foliage.',
      'Space plants adequately for air circulation.',
    ];
  } else if (normalizedLabel.contains('late blight')) {
    return [
      'Remove and destroy all infected plant parts immediately.',
      'Apply fungicides containing mancozeb or copper.',
      'Avoid overhead watering, especially in evening.',
      'Improve air circulation by pruning and spacing.',
      'Consider removing severely infected plants.',
    ];
  } else if (normalizedLabel.contains('septoria') || normalizedLabel.contains('leaf spot')) {
    return [
      'Remove infected lower leaves and destroy them.',
      'Apply fungicide containing chlorothalonil or copper.',
      'Mulch to prevent soil-borne spore splash.',
      'Water early in the day at plant base.',
      'Stake plants to improve air circulation.',
    ];
  } else if (normalizedLabel.contains('bacterial spot')) {
    return [
      'Remove and destroy severely infected plants.',
      'Apply copper-based bactericides.',
      'Disinfect tools between plants.',
      'Avoid working with plants when wet.',
      'Use drip irrigation instead of overhead watering.',
      'Plant disease-resistant varieties next season.',
    ];
  } else if (normalizedLabel.contains('leaf mold')) {
    return [
      'Improve greenhouse ventilation immediately.',
      'Remove infected leaves from bottom up.',
      'Apply sulfur or copper-based fungicides.',
      'Reduce humidity levels below 85%.',
      'Space plants for better air flow.',
    ];
  } else if (normalizedLabel.contains('target spot')) {
    return [
      'Remove and destroy infected plant material.',
      'Apply fungicides with active ingredients like chlorothalonil.',
      'Rotate crops to avoid disease recurrence.',
      'Maintain adequate plant spacing.',
      'Water at soil level to keep foliage dry.',
    ];
  } else if (normalizedLabel.contains('mosaic virus')) {
    return [
      'Remove and destroy infected plants immediately.',
      'Disinfect all tools with 10% bleach solution.',
      'Control aphid populations with insecticides.',
      'Wash hands thoroughly before handling healthy plants.',
      'Use virus-free certified seeds for future plantings.',
      'No cure available - focus on prevention.',
    ];
  } else if (normalizedLabel.contains('yellow leaf curl')) {
    return [
      'Remove severely infected plants to prevent spread.',
      'Control whitefly populations with yellow sticky traps.',
      'Apply systemic insecticides to control whiteflies.',
      'Use reflective mulches to deter whiteflies.',
      'Plant resistant varieties in future seasons.',
      'Remove weeds that host whiteflies.',
    ];
  }
  
  return [
    'Isolate affected plants if possible.',
    'Consult with local agricultural extension service.',
    'Take clear photos for professional diagnosis.',
    'Monitor closely for symptom progression.',
  ];
}

class ResultDetailPage extends StatelessWidget {
  const ResultDetailPage({super.key, required this.result, this.image});

  final InferenceResult result;
  final File? image;

  @override
  Widget build(BuildContext context) {
    final confidence = result.confidence;
    final isDiseased = !result.label.toLowerCase().contains('healthy');
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Success Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF22C55E),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.analysisComplete,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.aiIdentifiedPlant,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Image Card
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

                  // Plant Identification Section
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
                                color: const Color(0xFF22C55E).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.spa,
                                color: Color(0xFF22C55E),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.plantIdentification,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.detectedPlant,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getPlantName(result.label, locale),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.confidenceScore,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: confidence,
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(confidence * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF22C55E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Disease Detection Section
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
                              l10n.diseaseDetection,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.diseaseName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _getDiseaseName(result.label, locale),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDiseased
                                    ? const Color(0xFFFFEDD5)
                                    : const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isDiseased ? l10n.diseased : l10n.healthy,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDiseased
                                      ? const Color(0xFFC2410C)
                                      : const Color(0xFF166534),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.modelConfidence,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: confidence,
                                  minHeight: 10,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDiseased
                                        ? const Color(0xFFEA580C)
                                        : const Color(0xFF22C55E),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${(confidence * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDiseased
                                    ? const Color(0xFFEA580C)
                                    : const Color(0xFF22C55E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick Summary Section
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
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: Color(0xFF3B82F6),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.quickSummary,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.mainSymptoms,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _getDiseaseDescription(result.label, locale),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4B5563),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DiseaseDetailPage(
                              result: result,
                              image: image,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.viewDetailedInformation,
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

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF22C55E),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF22C55E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.scanAnother,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE047)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFCA8A04),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.disclaimer,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF92400E),
                              height: 1.4,
                            ),
                          ),
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
          const Text('• ', style: TextStyle(color: Color(0xFF111827))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


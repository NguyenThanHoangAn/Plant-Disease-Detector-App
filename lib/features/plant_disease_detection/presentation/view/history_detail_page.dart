import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import '../../../../services/history_service.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/disease_data.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key, required this.item});

  final ScanHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    final isHealthy = item.status == 'healthy';
    final description = DiseaseDataRepository.getDescription(item.diseaseName, locale);
    final symptoms = DiseaseDataRepository.getSymptoms(item.diseaseName, locale);
    final causes = DiseaseDataRepository.getCauses(item.diseaseName, locale);
    final preventionTips = DiseaseDataRepository.getPreventionTips(item.diseaseName, locale);
    final organicTreatments = DiseaseDataRepository.getOrganicTreatments(item.diseaseName, locale);
    final chemicalTreatments = DiseaseDataRepository.getChemicalTreatments(item.diseaseName, locale);
    final culturalPractices = DiseaseDataRepository.getCulturalPractices(item.diseaseName, locale);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.scanDetail),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (item.imagePath != null && File(item.imagePath!).existsSync())
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(item.imagePath!),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (item.imagePath != null && File(item.imagePath!).existsSync())
              const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.06),
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
                      Icon(
                        isHealthy ? Icons.check_circle : Icons.error_outline,
                        color: isHealthy ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DiseaseDataRepository.getPlantName(item.diseaseName, locale)} - ${DiseaseDataRepository.getDiseaseName(item.diseaseName, locale)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${l10n.status}: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      Text(
                        isHealthy ? l10n.healthy : l10n.diseased,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isHealthy ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('${l10n.confidence}: ', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                      Text(
                        '${item.confidence}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        '${item.date} • ${item.time}',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.notes,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.notesPlaceholder,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _InfoSectionCard(
              title: l10n.overview,
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _InfoSectionCard(
              title: l10n.mainSymptoms,
              child: _BulletList(items: symptoms),
            ),
            const SizedBox(height: 12),
            _InfoSectionCard(
              title: l10n.possibleCauses,
              child: _BulletList(items: causes),
            ),
            const SizedBox(height: 12),
            _InfoSectionCard(
              title: l10n.basicTreatmentSuggestions,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.organicOptions,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _BulletList(items: organicTreatments),
                  const SizedBox(height: 10),
                  Text(
                    l10n.chemicalOptions,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _BulletList(items: chemicalTreatments),
                  const SizedBox(height: 10),
                  Text(
                    l10n.culturalPractices,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _BulletList(items: culturalPractices),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _InfoSectionCard(
              title: l10n.preventionTips,
              child: _BulletList(items: preventionTips),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSectionCard extends StatelessWidget {
  const _InfoSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

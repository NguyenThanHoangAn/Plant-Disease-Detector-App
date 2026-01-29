import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../services/history_service.dart';
import '../../domain/models/disease_data.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key, required this.item});

  final ScanHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final isHealthy = item.status == 'healthy';
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.scanDetail),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF111827),
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
                      Icon(
                        isHealthy ? Icons.check_circle : Icons.error_outline,
                        color: isHealthy ? const Color(0xFF16A34A) : const Color(0xFFEA580C),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DiseaseDataRepository.getPlantName(item.diseaseName, locale)} - ${DiseaseDataRepository.getDiseaseName(item.diseaseName, locale)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${l10n.status}: ', style: const TextStyle(color: Color(0xFF6B7280))),
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
                      Text('${l10n.confidence}: ', style: const TextStyle(color: Color(0xFF6B7280))),
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
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(
                        '${item.date} • ${item.time}',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.notes,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.notesPlaceholder,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Color(0xFF4B5563),
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

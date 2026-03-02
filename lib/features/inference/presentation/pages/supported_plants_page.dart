import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'plant_diseases_list_page.dart';

class SupportedPlantsPage extends StatelessWidget {
  const SupportedPlantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      color: const Color(0xFFF9FAFB),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x11000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.supportedPlants,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '5 ${l10n.cropsAvailable}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Info Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.auto_fix_high,
                      color: Color(0xFF16A34A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.multiCropDetection,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF166534),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.multiCropDetectionDesc,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF166534),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Currently Supported Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        l10n.currentlySupported,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05,
                      children: [
                        _PlantCard(
                          emoji: '🍅',
                          nameKey: 'tomato',
                          scientificName: 'Solanum lycopersicum',
                          diseaseCount: 10,
                        ),
                        _PlantCard(
                          emoji: '🍇',
                          nameKey: 'grape',
                          scientificName: 'Vitis vinifera',
                          diseaseCount: 4,
                        ),
                        _PlantCard(
                          emoji: '🥔',
                          nameKey: 'potato',
                          scientificName: 'Solanum tuberosum',
                          diseaseCount: 3,
                        ),
                        _PlantCard(
                          emoji: '🍎',
                          nameKey: 'apple',
                          scientificName: 'Malus domestica',
                          diseaseCount: 4,
                        ),
                        _PlantCard(
                          emoji: '🌽',
                          nameKey: 'corn',
                          scientificName: 'Zea mays',
                          diseaseCount: 4,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Coming Soon Section
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            l10n.comingSoon,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.lock_clock,
                            size: 20,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                      children: [
                        _PlantCard(
                          emoji: '🌾',
                          nameKey: 'rice',
                          scientificName: 'Oryza sativa',
                          diseaseCount: 0,
                          isComingSoon: true,
                        ),
                        _PlantCard(
                          emoji: '🌶️',
                          nameKey: 'bellPepper',
                          scientificName: 'Capsicum annuum',
                          diseaseCount: 0,
                          isComingSoon: true,
                        ),
                        _PlantCard(
                          emoji: '🥒',
                          nameKey: 'cucumber',
                          scientificName: 'Cucumis sativus',
                          diseaseCount: 0,
                          isComingSoon: true,
                        ),
                        _PlantCard(
                          emoji: '🫘',
                          nameKey: 'soybean',
                          scientificName: 'Glycine max',
                          diseaseCount: 0,
                          isComingSoon: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.moreCropsWillBeAdded,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E40AF),
                                height: 1.3,
                              ),
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
          ],
        ),
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  const _PlantCard({
    required this.emoji,
    required this.nameKey,
    required this.scientificName,
    required this.diseaseCount,
    this.isComingSoon = false,
  });

  final String emoji;
  final String nameKey;
  final String scientificName;
  final int diseaseCount;
  final bool isComingSoon;

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
      default:
        return nameKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComingSoon ? const Color(0xFFE5E7EB) : const Color(0xFFBBF7D0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isComingSoon 
              ? null 
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlantDiseasesListPage(
                        plantKey: nameKey,
                        plantName: _getLocalizedName(l10n),
                      ),
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    if (isComingSoon)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.soon,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getLocalizedName(l10n),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isComingSoon ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scientificName,
                      style: TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: isComingSoon ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (!isComingSoon)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.medical_services,
                              size: 12,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$diseaseCount ${l10n.diseasesCount}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

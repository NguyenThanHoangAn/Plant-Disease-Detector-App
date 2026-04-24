import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import '../../../../services/history_service.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/data/models/disease_data.dart';
import 'history_detail_page.dart';

// StateNotifierProvider để tự động refresh khi có thay đổi
final historyProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<ScanHistoryItem>>>((ref) {
  return HistoryNotifier(ref.read(historyServiceProvider));
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<ScanHistoryItem>>> {
  HistoryNotifier(this._historyService) : super(const AsyncValue.loading()) {
    refresh();
  }

  final HistoryService _historyService;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final history = await _historyService.getHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearHistory() async {
    await _historyService.clearHistory();
    await refresh();
  }

  Future<void> deleteItem(int id) async {
    await _historyService.deleteHistoryItem(id);
    await refresh();
  }
}

enum _HistoryStatusFilter { all, healthy, diseased }

class TomatoHistoryView extends ConsumerStatefulWidget {
  const TomatoHistoryView({super.key});

  @override
  ConsumerState<TomatoHistoryView> createState() => _TomatoHistoryViewState();
}

class _TomatoHistoryViewState extends ConsumerState<TomatoHistoryView> {
  _HistoryStatusFilter _selectedFilter = _HistoryStatusFilter.all;

  List<ScanHistoryItem> _applyFilter(List<ScanHistoryItem> history) {
    switch (_selectedFilter) {
      case _HistoryStatusFilter.healthy:
        return history.where((item) => item.status == 'healthy').toList();
      case _HistoryStatusFilter.diseased:
        return history.where((item) => item.status != 'healthy').toList();
      case _HistoryStatusFilter.all:
        return history;
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final allLabel = locale == 'vi' ? 'Tất cả' : 'All';

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.scanHistory,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      historyAsync.when(
                        data: (history) => history.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(l10n.clearHistory),
                                      content: SingleChildScrollView(
                                        child: Text(l10n.clearHistoryConfirm),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: Text(l10n.cancel),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: Text(l10n.clear, style: const TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ref.read(historyProvider.notifier).clearHistory();
                                  }
                                },
                              )
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  historyAsync.when(
                    data: (history) {
                      final filtered = _applyFilter(history);
                      final countText = _selectedFilter == _HistoryStatusFilter.all
                          ? '${history.length} ${l10n.totalScans}'
                          : '${filtered.length}/${history.length} ${l10n.totalScans}';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            countText,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              ChoiceChip(
                                label: Text(allLabel),
                                selected: _selectedFilter == _HistoryStatusFilter.all,
                                onSelected: (_) {
                                  setState(() => _selectedFilter = _HistoryStatusFilter.all);
                                },
                              ),
                              ChoiceChip(
                                label: Text(l10n.healthy),
                                selected: _selectedFilter == _HistoryStatusFilter.healthy,
                                onSelected: (_) {
                                  setState(() => _selectedFilter = _HistoryStatusFilter.healthy);
                                },
                              ),
                              ChoiceChip(
                                label: Text(l10n.diseased),
                                selected: _selectedFilter == _HistoryStatusFilter.diseased,
                                onSelected: (_) {
                                  setState(() => _selectedFilter = _HistoryStatusFilter.diseased);
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    loading: () => Text(
                      l10n.loading,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    error: (_, __) => Text(
                      '0 ${l10n.totalScans}',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: historyAsync.when(
                data: (history) {
                  if (history.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noScanHistoryYet,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.startScanningToSeeResults,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final filteredHistory = _applyFilter(history);

                  if (filteredHistory.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt_off,
                            size: 56,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            locale == 'vi' ? 'Không có kết quả phù hợp bộ lọc' : 'No results for this filter',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(historyProvider.notifier).refresh();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        final item = filteredHistory[index];
                        final isHealthy = item.status == 'healthy';

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => HistoryDetailPage(item: item),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
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
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: item.imagePath != null && File(item.imagePath!).existsSync()
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.file(
                                            File(item.imagePath!),
                                            fit: BoxFit.cover,
                                            width: 72,
                                            height: 72,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${DiseaseDataRepository.getPlantName(item.diseaseName, locale)} - ${DiseaseDataRepository.getDiseaseName(item.diseaseName, locale)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF111827),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      isHealthy
                                                          ? Icons.check_circle
                                                          : Icons.error_outline,
                                                      size: 16,
                                                      color: isHealthy
                                                          ? const Color(0xFF16A34A)
                                                          : const Color(0xFFEA580C),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: isHealthy
                                                            ? const Color(0xFFDCFCE7)
                                                            : const Color(0xFFFFEDD5),
                                                        borderRadius: BorderRadius.circular(999),
                                                      ),
                                                      child: Text(
                                                        isHealthy ? l10n.healthy : l10n.diseased,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.w600,
                                                          color: isHealthy
                                                              ? const Color(0xFF166534)
                                                              : const Color(0xFFC2410C),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Color(0xFFEF4444),
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (ctx) => AlertDialog(
                                                      title: Text(l10n.deleteItem),
                                                      content: Text(l10n.deleteItemConfirm),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, false),
                                                          child: Text(l10n.cancel),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(ctx, true),
                                                          child: Text(
                                                            l10n.delete,
                                                            style: const TextStyle(color: Colors.red),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    await ref.read(historyProvider.notifier).deleteItem(item.id);
                                                    if (context.mounted) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(l10n.itemDeleted),
                                                          duration: const Duration(seconds: 2),
                                                          backgroundColor: const Color(0xFF16A34A),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                color: Color(0xFF9CA3AF),
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today_outlined,
                                            size: 13,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${item.date} • ${item.time}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading history',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.read(historyProvider.notifier).refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

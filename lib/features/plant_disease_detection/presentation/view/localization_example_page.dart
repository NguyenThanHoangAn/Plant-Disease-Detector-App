import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import 'package:flutter_deep_learning_demo/core/providers/locale_provider.dart';
import '../widgets/common/language_switcher.dart';

/// Example page demonstrating how to use localization
/// This is a reference implementation for developers
class LocalizationExamplePage extends ConsumerWidget {
  const LocalizationExamplePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the localization object
    final l10n = AppLocalizations.of(context)!;
    
    // Get current locale
    final locale = ref.watch(localeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [
          LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current language display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current: ${locale.languageCode == "vi" ? l10n.vietnamese : l10n.english}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(localeProvider.notifier).toggleLocale();
                      },
                      icon: const Icon(Icons.language),
                      label: Text(l10n.changeLanguage),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Example translations
            Text(
              'Example Translations:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            _TranslationExample(
              title: 'Navigation',
              items: [
                _TranslationItem('home', l10n.home),
                _TranslationItem('history', l10n.history),
                _TranslationItem('info', l10n.info),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _TranslationExample(
              title: 'Actions',
              items: [
                _TranslationItem('takePicture', l10n.takePicture),
                _TranslationItem('selectFromGallery', l10n.selectFromGallery),
                _TranslationItem('viewDetails', l10n.viewDetails),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _TranslationExample(
              title: 'Disease Information',
              items: [
                _TranslationItem('symptoms', l10n.symptoms),
                _TranslationItem('causes', l10n.causes),
                _TranslationItem('prevention', l10n.prevention),
                _TranslationItem('treatment', l10n.treatment),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _TranslationExample(
              title: 'Status Messages',
              items: [
                _TranslationItem('analyzing', l10n.analyzing),
                _TranslationItem('pleaseWait', l10n.pleaseWait),
                _TranslationItem('loading', l10n.loading),
                _TranslationItem('imageSelected', l10n.imageSelected),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationExample extends StatelessWidget {
  const _TranslationExample({
    required this.title,
    required this.items,
  });

  final String title;
  final List<_TranslationItem> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.key,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _TranslationItem {
  const _TranslationItem(this.key, this.value);
  
  final String key;
  final String value;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import 'package:flutter_deep_learning_demo/core/providers/locale_provider.dart';
import 'package:flutter_deep_learning_demo/core/providers/theme_provider.dart';

/// Language switcher dialog
class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: l10n.changeLanguage,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.changeLanguage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(l10n.vietnamese),
                  subtitle: const Text('Tiếng Việt'),
                  value: 'vi',
                  groupValue: locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLocale(Locale(value));
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(l10n.english),
                  subtitle: const Text('English'),
                  value: 'en',
                  groupValue: locale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLocale(Locale(value));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Simple language toggle button
class LanguageToggleButton extends ConsumerWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return IconButton(
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language, size: 20),
          const SizedBox(width: 4),
          Text(
            locale.languageCode.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      tooltip: locale.languageCode == 'vi' ? 'Switch to English' : 'Chuyển sang Tiếng Việt',
      onPressed: () {
        ref.read(localeProvider.notifier).toggleLocale();
      },
    );
  }
}

/// Theme toggle button for light/dark mode
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    
    return IconButton(
      icon: Icon(
        isDarkMode ? Icons.light_mode : Icons.dark_mode,
        size: 20,
      ),
      tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}

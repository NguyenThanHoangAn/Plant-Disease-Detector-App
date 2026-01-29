import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';
import 'features/inference/presentation/pages/splash_page.dart';

void main() {
  runApp(const ProviderScope(child: DeepLearningApp()));
}

class DeepLearningApp extends ConsumerWidget {
  const DeepLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Plant Disease Detection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      home: const SplashPage(),
    );
  }
}

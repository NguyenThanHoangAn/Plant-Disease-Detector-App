import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_deep_learning_demo/core/l10n/app_localizations.dart';
import 'package:flutter_deep_learning_demo/core/providers/locale_provider.dart';
import 'package:flutter_deep_learning_demo/core/providers/theme_provider.dart';
import 'package:flutter_deep_learning_demo/core/theme/app_theme.dart';
import 'package:flutter_deep_learning_demo/features/plant_disease_detection/presentation/view/splash_page.dart';

class DeepLearningApp extends ConsumerWidget {
  const DeepLearningApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Plant Disease Detection',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
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

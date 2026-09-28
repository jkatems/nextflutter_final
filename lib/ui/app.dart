import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/app_controller.dart';
import 'app_shell.dart';
import 'theme/app_theme.dart';

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: controller.preferences,
    child: AppShell(controller: controller),
    builder: (context, preferences, child) => MaterialApp(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      locale: Locale(controller.snapshot.language),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme(Brightness.light),
      darkTheme: appTheme(Brightness.dark),
      themeMode: controller.snapshot.dark ? ThemeMode.dark : ThemeMode.light,
      home: child,
    ),
  );
}

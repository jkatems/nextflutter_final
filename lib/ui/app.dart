import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/app_controller.dart';
import 'screens.dart';

const forest = Color(0xFF254D3F);
const paper = Color(0xFFF6F7F2);

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

ThemeData appTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = ColorScheme.fromSeed(
    seedColor: forest,
    brightness: brightness,
    primary: dark ? const Color(0xFFAFD3B8) : forest,
    surface: dark ? const Color(0xFF19241F) : Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'AdwaitaSans',
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? const Color(0xFF101A15) : paper,
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF101A15) : paper,
      scrolledUnderElevation: 0,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        height: 1.16,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -.8,
      ),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 50),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .5)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: .6),
    ),
  );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});
  final AppController controller;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = [l.home, l.tasks, l.stats, l.settings];
    const icons = [
      Icons.grid_view_rounded,
      Icons.check_circle_outline_rounded,
      Icons.bar_chart_rounded,
      Icons.tune_rounded,
    ];
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final c = widget.controller;
        final wide = MediaQuery.sizeOf(context).width >= 900;
        final pages = [
          HomeScreen(controller: c, onTasks: () => setState(() => index = 1)),
          TasksScreen(controller: c),
          StatsScreen(controller: c),
          SettingsScreen(controller: c),
        ];
        return Scaffold(
          appBar: wide
              ? null
              : AppBar(
                  title: const Brand(),
                  actions: [
                    if (index < 2)
                      IconButton(
                        key: const Key('addTask'),
                        tooltip: l.newTask,
                        onPressed: c.loading || c.error == 'load'
                            ? null
                            : () => openEditor(context, c),
                        icon: const Icon(Icons.add_rounded),
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
          bottomNavigationBar: wide
              ? null
              : NavigationBar(
                  selectedIndex: index,
                  onDestinationSelected: (value) =>
                      setState(() => index = value),
                  destinations: List.generate(
                    4,
                    (i) => NavigationDestination(
                      key: Key('nav$i'),
                      icon: Icon(icons[i]),
                      label: labels[i],
                    ),
                  ),
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  Container(
                    width: 240,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Brand(),
                          const SizedBox(height: 52),
                          for (var i = 0; i < 4; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                key: Key('nav$i'),
                                selected: index == i,
                                selectedTileColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: Icon(icons[i], size: 21),
                                title: Text(
                                  labels[i],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onTap: () => setState(() => index = i),
                              ),
                            ),
                          const Spacer(),
                          const Icon(Icons.spa_outlined, size: 30),
                          const SizedBox(height: 12),
                          Text(
                            l.offline,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: c.loading
                      ? const Center(child: CircularProgressIndicator())
                      : c.error == 'load'
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_rounded, size: 48),
                                const SizedBox(height: 16),
                                Text(l.loadError),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: c.initialize,
                                  child: Text(l.retry),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            if (c.error == 'save')
                              MaterialBanner(
                                content: Text(l.saveError),
                                actions: [
                                  TextButton(
                                    onPressed: () => setState(() {
                                      c.error = null;
                                    }),
                                    child: const Icon(
                                      Icons.close,
                                      semanticLabel: 'OK',
                                    ),
                                  ),
                                ],
                              ),
                            Expanded(child: pages[index]),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.spa_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 21,
        ),
      ),
      const SizedBox(width: 10),
      const Flexible(
        child: Text(
          'focusflow',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -.8,
          ),
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../state/app_controller.dart';
import 'navigation.dart';
import 'widgets/brand.dart';
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';

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
                        onPressed: c.loading || c.error == AppFailure.load
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
                      : c.error == AppFailure.load
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
                            if (c.error == AppFailure.save)
                              MaterialBanner(
                                content: Semantics(
                                  liveRegion: true,
                                  child: Text(l.saveError),
                                ),
                                actions: [
                                  IconButton(
                                    key: const Key('dismissError'),
                                    onPressed: c.dismissError,
                                    tooltip: MaterialLocalizations.of(
                                      context,
                                    ).closeButtonTooltip,
                                    icon: const Icon(Icons.close),
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

import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../../domain/task.dart';
import '../formatters.dart';
import '../widgets/widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stats = TaskStats(controller.tasks);
    return PageBody(
      children: [
        PageHeader(title: l.stats, subtitle: l.statsSubtitle),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.completionRate),
                const SizedBox(height: 14),
                Text(
                  '${(stats.progress * 100).round()} %',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 24),
                Semantics(
                  label: l.completionRate,
                  value: '${(stats.progress * 100).round()} %',
                  child: LinearProgressIndicator(
                    value: stats.progress,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                Text('${stats.completed} / ${stats.total} · ${l.completed}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(l.byCategory, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 18),
        for (final category in TaskCategory.values)
          _CategoryProgress(category: category, tasks: controller.tasks),
        const SizedBox(height: 24),
        Text(
          l.statsNote,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _CategoryProgress extends StatelessWidget {
  const _CategoryProgress({required this.category, required this.tasks});
  final TaskCategory category;
  final List<Task> tasks;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stats = TaskStats(
      tasks.where((t) => t.category == category).toList(),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(categoryIcon(category)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(categoryLabel(l, category))),
                  Text('${stats.completed} / ${stats.total}'),
                ],
              ),
              const SizedBox(height: 18),
              LinearProgressIndicator(
                value: stats.progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                semanticsLabel: categoryLabel(l, category),
                semanticsValue: '${(stats.progress * 100).round()}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

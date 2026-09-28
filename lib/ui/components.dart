import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/task.dart';
import '../l10n/app_localizations.dart';
import '../state/app_controller.dart';
import 'screens.dart';

String categoryLabel(AppLocalizations l, TaskCategory c) => switch (c) {
  TaskCategory.work => l.work,
  TaskCategory.personal => l.personal,
  TaskCategory.wellbeing => l.wellbeing,
};
String priorityLabel(AppLocalizations l, TaskPriority p) => switch (p) {
  TaskPriority.low => l.low,
  TaskPriority.medium => l.medium,
  TaskPriority.high => l.high,
};
IconData categoryIcon(TaskCategory c) => switch (c) {
  TaskCategory.work => Icons.work_outline_rounded,
  TaskCategory.personal => Icons.auto_awesome_outlined,
  TaskCategory.wellbeing => Icons.spa_outlined,
};
String dateLabel(BuildContext context, DateTime date) =>
    DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(date);

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });
  final String title;
  final String? subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 28),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        ?action,
      ],
    ),
  );
}

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: ListView.builder(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 600 ? 20 : 40,
        ),
        itemCount: children.length,
        itemBuilder: (context, i) => children[i],
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(label),
        ],
      ),
    ),
  );
}

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.controller});
  final Task task;
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: Row(
          children: [
            const SizedBox(width: 8),
            Semantics(
              label: task.completed
                  ? l.reopenTask(task.title)
                  : l.completeTask(task.title),
              child: Checkbox(
                key: Key('toggle-${task.id}'),
                value: task.completed,
                onChanged: controller.busy
                    ? null
                    : (_) => controller.toggle(task.id),
              ),
            ),
            Expanded(
              child: Semantics(
                label: l.openTask(task.title),
                button: true,
                child: InkWell(
                  key: Key('task-${task.id}'),
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          TaskDetailScreen(controller: controller, id: task.id),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 18, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              categoryLabel(l, task.category),
                              style: TextStyle(
                                color: scheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              dateLabel(context, task.dueDate),
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                            if (task.isOverdue(controller.clock()))
                              Text(
                                l.overdue,
                                style: TextStyle(
                                  color: scheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            if (task.priority == TaskPriority.high)
                              Text(
                                '↑ ${l.high}',
                                style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.chevron_right_rounded, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.filtered});
  final bool filtered;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Icon(
            filtered ? Icons.search_off_rounded : Icons.check_circle_outline,
            size: 52,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),
          Text(
            filtered ? l.noResults : l.emptyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            filtered ? l.noResultsBody : l.emptyBody,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

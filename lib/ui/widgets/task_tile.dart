import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../domain/task.dart';
import '../formatters.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.now,
    required this.busy,
    required this.onToggle,
    required this.onOpen,
  });
  final Task task;
  final DateTime now;
  final bool busy;
  final VoidCallback onToggle;
  final VoidCallback onOpen;
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
                onChanged: busy ? null : (_) => onToggle(),
              ),
            ),
            Expanded(
              child: Semantics(
                label: l.openTask(task.title),
                button: true,
                child: InkWell(
                  key: Key('task-${task.id}'),
                  borderRadius: BorderRadius.circular(20),
                  onTap: onOpen,
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
                            if (task.isOverdue(now))
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

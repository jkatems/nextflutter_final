import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../formatters.dart';
import '../widgets/widgets.dart';
import '../navigation.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.controller,
    required this.id,
  });
  final AppController controller;
  final String id;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final matches = controller.tasks.where((t) => t.id == id);
      if (matches.isEmpty) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(l.taskMissing)),
        );
      }
      final task = matches.first;
      return Scaffold(
        appBar: AppBar(
          title: Text(l.taskDetail),
          actions: [
            IconButton(
              key: const Key('editTask'),
              tooltip: l.editTask,
              onPressed: controller.busy
                  ? null
                  : () => openEditor(context, controller, task: task),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: PageBody(
          children: [
            Icon(
              categoryIcon(task.category),
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(task.title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(label: Text(categoryLabel(l, task.category))),
                Chip(label: Text(priorityLabel(l, task.priority))),
                Chip(label: Text(dateLabel(context, task.dueDate))),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  task.notes.isEmpty ? l.noNotes : task.notes,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 28),
            if (controller.error == AppFailure.save)
              Text(
                l.saveError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            FilledButton.icon(
              key: const Key('completeTask'),
              onPressed: controller.busy ? null : () => controller.toggle(id),
              icon: Icon(task.completed ? Icons.undo : Icons.check),
              label: Text(task.completed ? l.markPending : l.markDone),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              key: const Key('deleteTask'),
              onPressed: controller.busy
                  ? null
                  : () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(l.deleteTitle),
                          content: Text(l.deleteBody),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(l.cancel),
                            ),
                            FilledButton(
                              key: const Key('confirmDelete'),
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(l.delete),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        final ok = await controller.delete(id);
                        if (ok && context.mounted) Navigator.of(context).pop();
                      }
                    },
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              label: Text(
                l.delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      );
    },
  );
}

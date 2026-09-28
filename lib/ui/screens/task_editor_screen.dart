import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../../domain/task.dart';
import '../formatters.dart';

class TaskEditorScreen extends StatefulWidget {
  const TaskEditorScreen({super.key, required this.controller, this.task});
  final AppController controller;
  final Task? task;
  @override
  State<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends State<TaskEditorScreen> {
  final form = GlobalKey<FormState>();
  late final TextEditingController title = TextEditingController(
    text: widget.task?.title,
  );
  late final TextEditingController notes = TextEditingController(
    text: widget.task?.notes,
  );
  late TaskCategory category = widget.task?.category ?? TaskCategory.work;
  late TaskPriority priority = widget.task?.priority ?? TaskPriority.medium;
  late DateTime date = widget.task?.dueDate ?? widget.controller.clock();
  bool saving = false;
  bool failed = false;
  @override
  void dispose() {
    title.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate() || saving) return;
    setState(() {
      saving = true;
      failed = false;
    });
    final ok = await widget.controller.saveTask(
      id: widget.task?.id,
      title: title.text,
      notes: notes.text,
      category: category,
      priority: priority,
      dueDate: date,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        saving = false;
        failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? l.newTask : l.editTask)),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    l.heroTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    key: const Key('titleField'),
                    controller: title,
                    maxLength: 100,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: l.title),
                    validator: (value) => switch (validateTitle(value)) {
                      'required' => l.requiredTitle,
                      'tooLong' => l.longTitle,
                      _ => null,
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('notesField'),
                    controller: notes,
                    maxLines: 4,
                    maxLength: 2000,
                    decoration: InputDecoration(labelText: l.notes),
                    validator: (value) =>
                        (value?.length ?? 0) > 2000 ? l.longNotes : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<TaskCategory>(
                    initialValue: category,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.category),
                    items: TaskCategory.values
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(categoryLabel(l, c)),
                          ),
                        )
                        .toList(),
                    onChanged: (c) => setState(() => category = c!),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<TaskPriority>(
                    initialValue: priority,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.priority),
                    items: TaskPriority.values
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(priorityLabel(l, p)),
                          ),
                        )
                        .toList(),
                    onChanged: (p) => setState(() => priority = p!),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text('${l.dueDate} · ${dateLabel(context, date)}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(
                          date.year < 2020 ? date.year : 2020,
                        ),
                        lastDate: DateTime(
                          date.year > 2100 ? date.year : 2100,
                          12,
                          31,
                        ),
                      );
                      if (picked != null && mounted) {
                        setState(() => date = picked);
                      }
                    },
                  ),
                  if (failed)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        l.saveError,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('saveTask'),
                      onPressed: saving ? null : save,
                      icon: saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(l.save),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

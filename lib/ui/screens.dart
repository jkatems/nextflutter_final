import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../l10n/app_localizations.dart';
import '../state/app_controller.dart';
import 'components.dart';

Future<void> openEditor(
  BuildContext context,
  AppController controller, {
  Task? task,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => TaskEditorScreen(controller: controller, task: task),
  ),
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onTasks,
  });
  final AppController controller;
  final VoidCallback onTasks;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final stats = TaskStats(controller.tasks);
    final next = filterTasks(
      controller.tasks,
      filter: TaskFilter.pending,
    ).take(3).toList();
    return PageBody(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l.welcome,
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (MediaQuery.sizeOf(context).width > 600)
              Text(
                dateLabel(context, controller.clock()),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        const SizedBox(height: 22),
        Text(l.greeting, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(
          l.subtitle,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF254D3F),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(28),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: Color(0xFFDDE9BE),
                      size: 28,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l.heroTitle,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: -.7,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.heroBody,
                      style: const TextStyle(
                        color: Color(0xFFDFE9E3),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: onTasks,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFDDE9BE),
                        foregroundColor: const Color(0xFF203F32),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: Text(l.heroAction),
                    ),
                  ],
                ),
              ),
              if (MediaQuery.sizeOf(context).width > 1050)
                const Padding(
                  padding: EdgeInsets.all(28),
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.spa_rounded,
                      color: Color(0xFF99B69C),
                      size: 136,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final data in [
                (l.total, stats.total, Icons.layers_outlined),
                (l.pending, stats.pending, Icons.timelapse_rounded),
                (l.completed, stats.completed, Icons.task_alt_rounded),
              ])
                SizedBox(
                  width: constraints.maxWidth < 350
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 24) / 3,
                  child: StatCard(
                    label: data.$1,
                    value: '${data.$2}',
                    icon: data.$3,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l.today,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton(onPressed: onTasks, child: Text(l.seeAll)),
          ],
        ),
        const SizedBox(height: 14),
        if (next.isEmpty) const EmptyState(filtered: false),
        ...next.map((task) => TaskTile(task: task, controller: controller)),
        const SizedBox(height: 24),
        Text(l.spaces, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 18),
        // These image widgets are created and decoded only when the lazy list reaches them.
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final category in [
                TaskCategory.work,
                TaskCategory.wellbeing,
              ])
                SizedBox(
                  width: constraints.maxWidth < 500
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 16) / 2,
                  child: _SpaceCard(category: category, controller: controller),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(l.demoNotice, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SpaceCard extends StatelessWidget {
  const _SpaceCard({required this.category, required this.controller});
  final TaskCategory category;
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(categoryLabel(l, category))),
              body: TasksScreen(
                controller: controller,
                initialCategory: category,
              ),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/${category.name}.webp',
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              cacheWidth: 640,
              excludeFromSemantics: true,
              errorBuilder: (_, _, _) => const SizedBox(
                height: 130,
                child: Center(child: Icon(Icons.landscape_outlined)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(categoryIcon(category)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      categoryLabel(l, category),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({
    super.key,
    required this.controller,
    this.initialCategory,
  });
  final AppController controller;
  final TaskCategory? initialCategory;
  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String query = '';
  TaskFilter filter = TaskFilter.all;
  late TaskCategory? category = widget.initialCategory;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final tasks = filterTasks(
        widget.controller.tasks,
        query: query,
        filter: filter,
        category: category,
      );
      return Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(
                        title: l.tasks,
                        subtitle: l.countTasks(tasks.length),
                        action: FilledButton.icon(
                          key: const Key('createTask'),
                          onPressed: () =>
                              openEditor(context, widget.controller),
                          icon: const Icon(Icons.add, size: 20),
                          label: Text(l.newTask),
                        ),
                      ),
                      TextField(
                        key: const Key('search'),
                        onChanged: (value) => setState(() => query = value),
                        decoration: InputDecoration(
                          labelText: l.search,
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final f in TaskFilter.values)
                            FilterChip(
                              key: Key('filter-${f.name}'),
                              label: Text(switch (f) {
                                TaskFilter.all => l.all,
                                TaskFilter.pending => l.pending,
                                TaskFilter.completed => l.completed,
                              }),
                              selected: filter == f,
                              onSelected: (_) => setState(() => filter = f),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l.all),
                            selected: category == null,
                            onSelected: (_) => setState(() => category = null),
                          ),
                          for (final c in TaskCategory.values)
                            ChoiceChip(
                              label: Text(categoryLabel(l, c)),
                              selected: category == c,
                              onSelected: (_) => setState(() => category = c),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              if (tasks.isEmpty)
                SliverToBoxAdapter(
                  child: EmptyState(
                    filtered:
                        query.isNotEmpty ||
                        filter != TaskFilter.all ||
                        category != null,
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                sliver: SliverList.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) => TaskTile(
                    key: ValueKey(tasks[index].id),
                    task: tasks[index],
                    controller: widget.controller,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

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
            if (controller.error == 'save')
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return PageBody(
      children: [
        PageHeader(title: l.settings, subtitle: l.settingsSubtitle),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.language, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    for (final language in ['fr', 'en'])
                      ChoiceChip(
                        key: Key('language-$language'),
                        label: Text(language == 'fr' ? 'Français' : 'English'),
                        selected: controller.snapshot.language == language,
                        onSelected: controller.busy
                            ? null
                            : (_) => controller.setLanguage(language),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  l.appearance,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SwitchListTile(
                  key: const Key('darkMode'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.darkMode),
                  subtitle: Text(l.themeHint),
                  value: controller.snapshot.dark,
                  onChanged: controller.busy ? null : controller.setDark,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lock_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l.localFirst,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(l.privacyBody),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(l.about, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(l.version),
      ],
    );
  }
}

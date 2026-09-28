import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../../domain/task.dart';
import '../formatters.dart';
import '../widgets/widgets.dart';
import '../navigation.dart';

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
                    now: widget.controller.clock(),
                    busy: widget.controller.busy,
                    onToggle: () => widget.controller.toggle(tasks[index].id),
                    onOpen: () =>
                        openTask(context, widget.controller, tasks[index].id),
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

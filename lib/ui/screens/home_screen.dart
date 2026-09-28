import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../state/app_controller.dart';
import '../../domain/task.dart';
import '../formatters.dart';
import '../widgets/widgets.dart';
import '../navigation.dart';
import 'tasks_screen.dart';

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
        ...next.map(
          (task) => TaskTile(
            task: task,
            now: controller.clock(),
            busy: controller.busy,
            onToggle: () => controller.toggle(task.id),
            onOpen: () => openTask(context, controller, task.id),
          ),
        ),
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

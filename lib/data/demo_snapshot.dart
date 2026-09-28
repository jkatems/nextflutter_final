import '../domain/app_snapshot.dart';
import '../domain/task.dart';

AppSnapshot demoSnapshot(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  return AppSnapshot(
    tasks: [
      Task(
        id: 'welcome-1',
        title: 'Dessiner les premières idées',
        notes:
            'Prendre une feuille, explorer trois pistes et garder celle qui vous inspire.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        dueDate: today,
      ),
      Task(
        id: 'welcome-2',
        title: 'Une pause pour soi',
        notes: 'Vingt minutes de marche, sans écran. Juste prendre l’air.',
        category: TaskCategory.wellbeing,
        priority: TaskPriority.medium,
        dueDate: today,
      ),
      Task(
        id: 'welcome-3',
        title: 'Lire un nouveau chapitre',
        category: TaskCategory.personal,
        priority: TaskPriority.low,
        dueDate: today.add(const Duration(days: 1)),
      ),
      Task(
        id: 'welcome-4',
        title: 'Préparer la semaine',
        category: TaskCategory.personal,
        priority: TaskPriority.medium,
        dueDate: today,
        completed: true,
      ),
    ],
  );
}

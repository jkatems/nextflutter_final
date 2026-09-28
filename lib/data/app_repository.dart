import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/task.dart';

class AppSnapshot {
  AppSnapshot({
    required List<Task> tasks,
    this.language = 'fr',
    this.dark = false,
  }) : tasks = List.unmodifiable(tasks);
  final List<Task> tasks;
  final String language;
  final bool dark;
  AppSnapshot copyWith({List<Task>? tasks, String? language, bool? dark}) =>
      AppSnapshot(
        tasks: tasks ?? this.tasks,
        language: language ?? this.language,
        dark: dark ?? this.dark,
      );
  String encode() => jsonEncode({
    'schema': 1,
    'language': language,
    'dark': dark,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  });
  factory AppSnapshot.decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    if (json['schema'] != 1 || !['fr', 'en'].contains(json['language'])) {
      throw const FormatException('Unsupported snapshot');
    }
    final tasks = (json['tasks'] as List)
        .map((t) => Task.fromJson(t as Map<String, dynamic>))
        .toList();
    if (tasks.map((t) => t.id).toSet().length != tasks.length) {
      throw const FormatException('Duplicate task ID');
    }
    return AppSnapshot(
      tasks: tasks,
      language: json['language'] as String,
      dark: json['dark'] as bool,
    );
  }
}

abstract interface class AppRepository {
  Future<AppSnapshot?> load();
  Future<void> save(AppSnapshot snapshot);
}

class PreferencesRepository implements AppRepository {
  PreferencesRepository([this.preferences]);
  static const storageKey = 'focusflow.snapshot.v1';
  final SharedPreferences? preferences;
  @override
  Future<AppSnapshot?> load() async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    return raw == null ? null : AppSnapshot.decode(raw);
  }

  @override
  Future<void> save(AppSnapshot snapshot) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    if (!await prefs.setString(storageKey, snapshot.encode())) {
      throw StateError('Storage unavailable');
    }
  }
}

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

import 'dart:convert';
import 'task.dart';

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

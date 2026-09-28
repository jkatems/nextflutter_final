import 'package:flutter/foundation.dart';
import '../data/app_repository.dart';
import '../domain/task.dart';

class AppController extends ChangeNotifier {
  AppController(this.repository, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;
  final AppRepository repository;
  final DateTime Function() clock;
  AppSnapshot _snapshot = AppSnapshot(tasks: []);
  AppSnapshot get snapshot => _snapshot;
  List<Task> get tasks => _snapshot.tasks;
  bool loading = true;
  bool busy = false;
  String? error;
  int _sequence = 0;
  final preferences = ValueNotifier<(String, bool)>(('fr', false));
  void _syncPreferences() {
    preferences.value = (snapshot.language, snapshot.dark);
  }

  @override
  void dispose() {
    preferences.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final saved = await repository.load();
      if (saved == null) {
        final initial = demoSnapshot(clock());
        await repository.save(initial);
        _snapshot = initial;
      } else {
        _snapshot = saved;
      }
    } catch (_) {
      error = 'load';
    }
    _syncPreferences();
    loading = false;
    notifyListeners();
  }

  Future<bool> _commit(AppSnapshot next) async {
    if (busy || loading || error == 'load') return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await repository.save(next);
      _snapshot = next;
      _syncPreferences();
      return true;
    } catch (_) {
      error = 'save';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<bool> saveTask({
    String? id,
    required String title,
    required String notes,
    required TaskCategory category,
    required TaskPriority priority,
    required DateTime dueDate,
  }) async {
    if (validateTitle(title) != null || notes.length > 2000) return false;
    final index = tasks.indexWhere((t) => t.id == id);
    if (id != null && index < 0) return false;
    final task = Task(
      id: id ?? '${clock().microsecondsSinceEpoch}-${_sequence++}',
      title: title.trim(),
      notes: notes.trim(),
      category: category,
      priority: priority,
      dueDate: DateTime(dueDate.year, dueDate.month, dueDate.day),
      completed: index >= 0 ? tasks[index].completed : false,
    );
    final next = [...tasks];
    if (index >= 0) {
      next[index] = task;
    } else {
      next.add(task);
    }
    return _commit(_snapshot.copyWith(tasks: next));
  }

  Future<bool> toggle(String id) async {
    if (!tasks.any((t) => t.id == id)) return false;
    return _commit(
      _snapshot.copyWith(
        tasks: tasks
            .map((t) => t.id == id ? t.copyWith(completed: !t.completed) : t)
            .toList(),
      ),
    );
  }

  Future<bool> delete(String id) async {
    if (!tasks.any((t) => t.id == id)) return false;
    return _commit(
      _snapshot.copyWith(tasks: tasks.where((t) => t.id != id).toList()),
    );
  }

  Future<bool> setLanguage(String language) async {
    if (!['fr', 'en'].contains(language)) return false;
    if (language == snapshot.language) return true;
    return _commit(_snapshot.copyWith(language: language));
  }

  Future<bool> setDark(bool dark) => _commit(_snapshot.copyWith(dark: dark));
}

import 'package:flutter/foundation.dart';
import '../domain/app_repository.dart';
import '../domain/app_snapshot.dart';
import '../domain/task.dart';

enum AppFailure { load, save }

/// Application state. Widgets observe it and issue commands, never mutate it.
/// Persistence and the initial data factory are injected at the composition root.
class AppController extends ChangeNotifier {
  AppController(
    this.repository, {
    DateTime Function()? clock,
    AppSnapshot Function(DateTime)? initialSnapshot,
  }) : clock = clock ?? DateTime.now,
       _initialSnapshot = initialSnapshot ?? _emptySnapshot;
  static AppSnapshot _emptySnapshot(DateTime _) => AppSnapshot(tasks: []);
  final AppSnapshot Function(DateTime) _initialSnapshot;
  final AppRepository repository;
  final DateTime Function() clock;
  AppSnapshot _snapshot = AppSnapshot(tasks: []);
  AppSnapshot get snapshot => _snapshot;
  List<Task> get tasks => _snapshot.tasks;
  bool _loading = true;
  bool _busy = false;
  AppFailure? _error;
  bool _disposed = false;
  bool _initializing = false;
  bool get loading => _loading;
  bool get busy => _busy;
  AppFailure? get error => _error;

  /// A read failure remains blocking until initialize succeeds.
  void dismissError() {
    if (_error != AppFailure.save || _disposed) return;
    _error = null;
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  int _sequence = 0;
  final _preferences = ValueNotifier<(String, bool)>(('fr', false));
  ValueListenable<(String, bool)> get preferences => _preferences;
  void _syncPreferences() {
    if (!_disposed) _preferences.value = (snapshot.language, snapshot.dark);
  }

  @override
  void dispose() {
    _disposed = true;
    _preferences.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    if (_disposed || _initializing || busy) return;
    _initializing = true;
    _loading = true;
    _error = null;
    _notify();
    try {
      final saved = await repository.load();
      if (saved == null) {
        final initial = _initialSnapshot(clock());
        await repository.save(initial);
        _snapshot = initial;
      } else {
        _snapshot = saved;
      }
    } catch (_) {
      _error = AppFailure.load;
    }
    _syncPreferences();
    _initializing = false;
    _loading = false;
    _notify();
  }

  Future<bool> _commit(AppSnapshot next) async {
    if (_disposed || busy || loading || _error == AppFailure.load) return false;
    _busy = true;
    _error = null;
    _notify();
    try {
      await repository.save(next);
      _snapshot = next;
      _syncPreferences();
      return true;
    } catch (_) {
      _error = AppFailure.save;
      return false;
    } finally {
      _busy = false;
      _notify();
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

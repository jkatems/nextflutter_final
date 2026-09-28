import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/task.dart';
import '../helpers.dart';

void main() {
  group('Task and validation', () {
    test('JSON roundtrip preserves every field', () {
      final t = sampleTask();
      expect(Task.fromJson(t.toJson()).toJson(), t.toJson());
    });
    test('copy keeps identity and leaves original immutable', () {
      final original = sampleTask();
      final changed = original.copyWith(title: 'Nouveau', completed: true);
      expect(changed.id, original.id);
      expect(changed.completed, isTrue);
      expect(original.completed, isFalse);
      expect(original.title, isNot('Nouveau'));
    });
    test('empty and whitespace title are rejected', () {
      expect(validateTitle(null), 'required');
      expect(validateTitle('  '), 'required');
    });
    test('title boundary is 100 characters after trimming', () {
      expect(validateTitle(' ${'a' * 100} '), isNull);
      expect(validateTitle('a' * 101), 'tooLong');
    });
    test('due today is not overdue even at night', () {
      expect(
        sampleTask(dueDate: DateTime(2026, 9, 27)).isOverdue(testNow),
        isFalse,
      );
    });
    test('yesterday is overdue only while pending', () {
      final t = sampleTask(dueDate: DateTime(2026, 9, 26));
      expect(t.isOverdue(testNow), isTrue);
      expect(t.copyWith(completed: true).isOverdue(testNow), isFalse);
    });
    test('invalid serialized title is rejected', () {
      expect(
        () => Task.fromJson({...sampleTask().toJson(), 'title': ' '}),
        throwsFormatException,
      );
    });
  });
  group('Filtering and statistics', () {
    final tasks = [
      sampleTask(),
      sampleTask(
        id: 'b',
        title: 'Lire',
        completed: true,
        category: TaskCategory.personal,
      ),
      sampleTask(
        id: 'c',
        title: 'Marcher',
        category: TaskCategory.wellbeing,
        dueDate: DateTime(2026, 9, 26),
      ),
    ];
    test('query matches case insensitively with whitespace', () {
      expect(filterTasks(tasks, query: '  PROJET ').single.id, 'a');
    });
    test('query also searches notes', () {
      expect(filterTasks(tasks, query: 'utile').length, 3);
    });
    test('category and completion filters combine', () {
      expect(
        filterTasks(
          tasks,
          category: TaskCategory.personal,
          filter: TaskFilter.completed,
        ).single.id,
        'b',
      );
      expect(
        filterTasks(
          tasks,
          category: TaskCategory.personal,
          filter: TaskFilter.pending,
        ),
        isEmpty,
      );
    });
    test('sort puts pending tasks first ordered by date', () {
      expect(filterTasks(tasks).map((t) => t.id), ['c', 'a', 'b']);
      expect(tasks.first.id, 'a');
    });
    test('empty stats never divide by zero', () {
      final s = TaskStats([]);
      expect(s.progress, 0);
      expect(s.pending, 0);
    });
    test('stats reflect completed and pending totals', () {
      final s = TaskStats(tasks);
      expect(s.total, 3);
      expect(s.completed, 1);
      expect(s.pending, 2);
      expect(s.progress, closeTo(1 / 3, .001));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/domain/task.dart';
import 'package:focus_flow/state/app_controller.dart';
import '../helpers.dart';

Future<bool> add(
  AppController c, {
  String title = 'Nouvelle tâche',
  String? id,
  String notes = '',
}) => c.saveTask(
  id: id,
  title: title,
  notes: notes,
  category: TaskCategory.personal,
  priority: TaskPriority.low,
  dueDate: testNow,
);
void main() {
  test('first launch saves initial sample once', () async {
    final repository = MemoryRepository();
    final c = await testController(repository: repository);
    addTearDown(c.dispose);
    expect(c.tasks.length, 4);
    expect(repository.saves, 1);
    await c.initialize();
    expect(repository.saves, 1);
  });
  test('add trims title and persists', () async {
    final c = await testController(tasks: []);
    addTearDown(c.dispose);
    expect(await add(c, title: '  Bonjour  '), isTrue);
    expect(c.tasks.single.title, 'Bonjour');
    expect(c.tasks.single.dueDate.hour, 0);
  });
  test('blank task is rejected without save', () async {
    final r = MemoryRepository(AppSnapshot(tasks: []));
    final c = await testController(repository: r);
    addTearDown(c.dispose);
    expect(await add(c, title: ' '), isFalse);
    expect(r.saves, 0);
  });
  test('long notes are rejected', () async {
    final c = await testController();
    addTearDown(c.dispose);
    expect(await add(c, notes: 'a' * 2001), isFalse);
  });
  test('IDs remain unique with a frozen clock', () async {
    final c = await testController(tasks: []);
    addTearDown(c.dispose);
    await add(c);
    await add(c);
    expect(c.tasks.map((t) => t.id).toSet().length, 2);
  });
  test('editing preserves completion and ID', () async {
    final c = await testController(tasks: [sampleTask(completed: true)]);
    addTearDown(c.dispose);
    await add(c, id: 'a', title: 'Modifiée');
    expect(c.tasks.single.completed, isTrue);
    expect(c.tasks.single.id, 'a');
  });
  test('unknown IDs do not insert or delete other tasks', () async {
    final c = await testController();
    addTearDown(c.dispose);
    expect(await add(c, id: 'missing'), isFalse);
    expect(await c.delete('missing'), isFalse);
    expect(await c.toggle('missing'), isFalse);
    expect(c.tasks.length, 1);
  });
  test('toggle and delete persist correctly', () async {
    final c = await testController();
    addTearDown(c.dispose);
    await c.toggle('a');
    expect(c.tasks.single.completed, isTrue);
    await c.toggle('a');
    expect(c.tasks.single.completed, isFalse);
    await c.delete('a');
    expect(c.tasks, isEmpty);
  });
  test('failed write keeps previous state and permits retry', () async {
    final r = MemoryRepository(AppSnapshot(tasks: [sampleTask()]));
    final c = await testController(repository: r);
    addTearDown(c.dispose);
    r.failSave = true;
    expect(await c.toggle('a'), isFalse);
    expect(c.tasks.single.completed, isFalse);
    expect(c.error, AppFailure.save);
    expect(c.busy, isFalse);
    r.failSave = false;
    expect(await c.toggle('a'), isTrue);
    expect(c.error, isNull);
  });
  test(
    'read error preserves repository and blocks mutation until retry',
    () async {
      final r = MemoryRepository(AppSnapshot(tasks: [sampleTask()]))
        ..failLoad = true;
      final c = await testController(repository: r);
      addTearDown(c.dispose);
      expect(c.error, AppFailure.load);
      expect(await add(c), isFalse);
      expect(r.saves, 0);
      r.failLoad = false;
      await c.initialize();
      expect(c.tasks.single.id, 'a');
      expect(c.error, isNull);
    },
  );
  test('language and theme survive controller recreation', () async {
    final r = MemoryRepository(AppSnapshot(tasks: []));
    final c = await testController(repository: r);
    addTearDown(c.dispose);
    await c.setLanguage('en');
    await c.setDark(true);
    final next = await testController(repository: r);
    addTearDown(next.dispose);
    expect(next.snapshot.language, 'en');
    expect(next.snapshot.dark, isTrue);
    expect(await next.setLanguage('xx'), isFalse);
  });
  test('simultaneous saves cannot overwrite each other', () async {
    final c = await testController(tasks: []);
    addTearDown(c.dispose);
    final results = await Future.wait([
      add(c, title: 'One'),
      add(c, title: 'Two'),
    ]);
    expect(results, [true, false]);
    expect(c.tasks.single.title, 'One');
  });
}

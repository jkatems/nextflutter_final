import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/app_repository.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/state/app_controller.dart';
import '../helpers.dart';

class DelayedRepository implements AppRepository {
  final pending = Completer<void>();
  int writes = 0;
  @override
  Future<AppSnapshot?> load() async => AppSnapshot(tasks: [sampleTask()]);
  @override
  Future<void> save(AppSnapshot snapshot) async {
    writes++;
    await pending.future;
  }
}

void main() {
  test('save error dismissal notifies UI without writing', () async {
    final r = MemoryRepository(AppSnapshot(tasks: [sampleTask()]));
    final c = await testController(repository: r);
    addTearDown(c.dispose);
    r.failSave = true;
    await c.toggle('a');
    var notifications = 0;
    c.addListener(() => notifications++);
    c.dismissError();
    expect(c.error, isNull);
    expect(notifications, 1);
    expect(r.saves, 0);
    expect(c.tasks.single.completed, isFalse);
  });
  test('read failure cannot be dismissed to bypass recovery', () async {
    final r = MemoryRepository()..failLoad = true;
    final c = await testController(repository: r);
    addTearDown(c.dispose);
    c.dismissError();
    expect(c.error, AppFailure.load);
    expect(await c.setDark(true), isFalse);
  });
  test('task updates do not notify application theme or locale', () async {
    final c = await testController();
    addTearDown(c.dispose);
    var updates = 0;
    c.preferences.addListener(() => updates++);
    await c.toggle('a');
    expect(updates, 0);
    await c.setLanguage('en');
    expect(updates, 1);
    await c.setLanguage('en');
    expect(updates, 1);
  });
  test(
    'initial snapshot is injected and respects the injected clock',
    () async {
      DateTime? received;
      final c = AppController(
        MemoryRepository(),
        clock: () => testNow,
        initialSnapshot: (now) {
          received = now;
          return AppSnapshot(tasks: []);
        },
      );
      addTearDown(c.dispose);
      await c.initialize();
      expect(received, testNow);
      expect(c.tasks, isEmpty);
    },
  );
  test('controller default has no dependency on demo data', () async {
    final c = AppController(MemoryRepository());
    addTearDown(c.dispose);
    await c.initialize();
    expect(c.tasks, isEmpty);
  });
  test(
    'disposing during a write does not notify a disposed listener',
    () async {
      final r = DelayedRepository();
      final c = AppController(r);
      await c.initialize();
      final save = c.toggle('a');
      expect(c.busy, isTrue);
      c.dispose();
      r.pending.complete();
      expect(await save, isTrue);
      expect(await c.toggle('a'), isFalse);
      expect(r.writes, 1);
    },
  );
  test('initialization cannot race an in-flight write', () async {
    final r = DelayedRepository();
    final c = AppController(r);
    addTearDown(c.dispose);
    await c.initialize();
    final save = c.toggle('a');
    await c.initialize();
    expect(c.busy, isTrue);
    r.pending.complete();
    expect(await save, isTrue);
    expect(c.tasks.single.completed, isTrue);
  });
}

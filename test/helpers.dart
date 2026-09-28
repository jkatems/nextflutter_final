import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/domain/app_repository.dart';
import 'package:focus_flow/domain/task.dart';
import 'package:focus_flow/data/demo_snapshot.dart';
import 'package:focus_flow/state/app_controller.dart';

final testNow = DateTime(2026, 9, 27, 12);
Task sampleTask({
  String id = 'a',
  String title = 'Préparer le projet',
  bool completed = false,
  TaskCategory category = TaskCategory.work,
  DateTime? dueDate,
}) => Task(
  id: id,
  title: title,
  notes: 'Une note utile',
  category: category,
  priority: TaskPriority.high,
  dueDate: dueDate ?? testNow,
  completed: completed,
);

class MemoryRepository implements AppRepository {
  MemoryRepository([this.value]);
  AppSnapshot? value;
  bool failLoad = false;
  bool failSave = false;
  int saves = 0;
  @override
  Future<AppSnapshot?> load() async {
    if (failLoad) throw StateError('read');
    return value;
  }

  @override
  Future<void> save(AppSnapshot snapshot) async {
    if (failSave) throw StateError('write');
    saves++;
    value = AppSnapshot.decode(snapshot.encode());
  }
}

Future<AppController> testController({
  List<Task>? tasks,
  MemoryRepository? repository,
}) async {
  final c = AppController(
    repository ?? MemoryRepository(AppSnapshot(tasks: tasks ?? [sampleTask()])),
    clock: () => testNow,
    initialSnapshot: demoSnapshot,
  );
  await c.initialize();
  return c;
}

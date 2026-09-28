import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/task.dart';
import 'package:focus_flow/ui/widgets/task_tile.dart';
import '../helpers.dart';
import '../widget_harness.dart';

void main() {
  testWidgets('1000 tasks mount only the visible rows and viewport cache', (
    tester,
  ) async {
    final tasks = List<Task>.generate(
      1000,
      (i) => sampleTask(id: '$i', title: 'Task $i'),
    );
    await mount(tester, tasks: tasks);
    await tap(tester, 'nav1');
    expect(find.byType(TaskTile).evaluate().length, lessThan(25));
    expect(find.byKey(const Key('task-999')), findsNothing);
    await tester.fling(
      find.byType(CustomScrollView),
      const Offset(0, -700),
      1400,
    );
    await tester.pumpAndSettle();
    expect(find.byType(TaskTile).evaluate().length, lessThan(25));
    expect(tester.takeException(), isNull);
  });
}

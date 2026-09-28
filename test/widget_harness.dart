import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/task.dart';
import 'package:focus_flow/state/app_controller.dart';
import 'package:focus_flow/ui/app.dart';
import 'helpers.dart';

Future<AppController> mount(
  WidgetTester tester, {
  List<Task>? tasks,
  MemoryRepository? repository,
  Size size = const Size(430, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final c = await testController(tasks: tasks, repository: repository);
  addTearDown(c.dispose);
  await tester.pumpWidget(FocusFlowApp(controller: c));
  await tester.pumpAndSettle();
  return c;
}

Future<void> tap(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

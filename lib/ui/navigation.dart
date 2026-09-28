import 'package:flutter/material.dart';
import '../domain/task.dart';
import '../state/app_controller.dart';
import 'screens/task_editor_screen.dart';
import 'screens/task_detail_screen.dart';

Future<void> openEditor(
  BuildContext context,
  AppController controller, {
  Task? task,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => TaskEditorScreen(controller: controller, task: task),
  ),
);

Future<void> openTask(
  BuildContext context,
  AppController controller,
  String id,
) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => TaskDetailScreen(controller: controller, id: id),
  ),
);

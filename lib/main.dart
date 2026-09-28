import 'package:flutter/material.dart';
import 'bootstrap.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = createAppController();
  runApp(FocusFlowApp(controller: controller));
  await controller.initialize();
}

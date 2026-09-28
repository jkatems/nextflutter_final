import 'package:flutter/material.dart';
import 'data/app_repository.dart';
import 'state/app_controller.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController(PreferencesRepository());
  runApp(FocusFlowApp(controller: controller));
  await controller.initialize();
}

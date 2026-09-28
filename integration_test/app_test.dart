import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_flow/data/preferences_repository.dart';
import 'package:focus_flow/state/app_controller.dart';
import 'package:focus_flow/bootstrap.dart';
import 'package:focus_flow/ui/app.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const testStorageKey = 'focusflow.integration-test.v1';
  late SharedPreferences prefs;
  late AppController controller;
  Future<void> start(WidgetTester tester) async {
    prefs = await SharedPreferences.getInstance();
    // This suite runs in a disposable browser profile/device; only our app key is removed.
    await prefs.remove(testStorageKey);
    controller = createAppController(
      repository: PreferencesRepository(
        preferences: prefs,
        key: testStorageKey,
      ),
    );
    await controller.initialize();
    await tester.pumpWidget(FocusFlowApp(controller: controller));
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(Key(key)));
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  Future<void> screenshot(String name) async {
    if (const bool.fromEnvironment('SCREENSHOTS')) {
      await binding.takeScreenshot(name);
    }
  }

  testWidgets(
    'create, complete and restore a task with the real local storage adapter',
    (tester) async {
      await start(tester);
      await screenshot('01-overview-fr');
      await tap(tester, 'nav1');
      await tap(tester, 'createTask');
      await screenshot('02-create-fr');
      await tester.enterText(
        find.byKey(const Key('titleField')),
        'Livrer FocusFlow',
      );
      await tester.enterText(
        find.byKey(const Key('notesField')),
        'Parcours de production validé',
      );
      await tap(tester, 'saveTask');
      await tester.enterText(
        find.byKey(const Key('search')),
        'Livrer FocusFlow',
      );
      await tester.pumpAndSettle();
      final task = controller.tasks.singleWhere(
        (t) => t.title == 'Livrer FocusFlow',
      );
      await screenshot('03-tasks-fr');
      await tap(tester, 'task-${task.id}');
      await tap(tester, 'completeTask');
      await screenshot('04-detail-fr');
      expect(
        controller.tasks.singleWhere((t) => t.id == task.id).completed,
        isTrue,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      await prefs.reload();
      controller = createAppController(
        repository: PreferencesRepository(
          preferences: prefs,
          key: testStorageKey,
        ),
      );
      await controller.initialize();
      await tester.pumpWidget(FocusFlowApp(controller: controller));
      await tester.pumpAndSettle();
      expect(
        controller.tasks.singleWhere((t) => t.id == task.id).completed,
        isTrue,
      );
      await tap(tester, 'nav2');
      await screenshot('05-insights-fr');
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    },
  );
  testWidgets(
    'edit, switch language/theme, restart and delete with confirmation',
    (tester) async {
      await start(tester);
      await tap(tester, 'nav1');
      await tap(tester, 'task-welcome-1');
      await tap(tester, 'editTask');
      await tester.enterText(
        find.byKey(const Key('titleField')),
        'Release checklist',
      );
      await tap(tester, 'saveTask');
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tap(tester, 'nav3');
      await tap(tester, 'language-en');
      await tap(tester, 'darkMode');
      await screenshot('06-settings-en-dark');
      expect(find.text('Dark mode'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
      await prefs.reload();
      controller = createAppController(
        repository: PreferencesRepository(
          preferences: prefs,
          key: testStorageKey,
        ),
      );
      await controller.initialize();
      await tester.pumpWidget(FocusFlowApp(controller: controller));
      await tester.pumpAndSettle();
      expect(controller.snapshot.language, 'en');
      expect(controller.snapshot.dark, isTrue);
      await tap(tester, 'nav1');
      await tap(tester, 'task-welcome-1');
      await tap(tester, 'deleteTask');
      expect(find.text('Delete this task?'), findsOneWidget);
      await tap(tester, 'confirmDelete');
      expect(controller.tasks.any((t) => t.id == 'welcome-1'), isFalse);
      await prefs.reload();
      expect(
        (await PreferencesRepository(
          preferences: prefs,
          key: testStorageKey,
        ).load())!.tasks.any((t) => t.id == 'welcome-1'),
        isFalse,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/ui/screens/task_editor_screen.dart';
import 'package:focus_flow/ui/screens/task_detail_screen.dart';
import 'package:focus_flow/ui/screens/settings_screen.dart';
import '../helpers.dart';
import '../widget_harness.dart';

void main() {
  testWidgets('overview renders and opens task list', (tester) async {
    await mount(tester);
    expect(
      find.text('Un peu de clarté,\nbeaucoup de possibilités.'),
      findsOneWidget,
    );
    await tap(tester, 'nav1');
    expect(find.byKey(const Key('search')), findsOneWidget);
  });
  testWidgets('blank title shows accessible validation', (tester) async {
    await mount(tester);
    await tap(tester, 'addTask');
    await tap(tester, 'saveTask');
    expect(find.text('Ajoutez un titre pour continuer.'), findsOneWidget);
  });
  testWidgets('create form persists then closes', (tester) async {
    final c = await mount(tester, tasks: []);
    await tap(tester, 'addTask');
    await tester.enterText(
      find.byKey(const Key('titleField')),
      'Une nouvelle idée',
    );
    await tap(tester, 'saveTask');
    expect(c.tasks.single.title, 'Une nouvelle idée');
    expect(find.byType(TaskEditorScreen), findsNothing);
  });
  testWidgets('search handles no results and matching text', (tester) async {
    await mount(tester);
    await tap(tester, 'nav1');
    await tester.enterText(find.byKey(const Key('search')), 'introuvable');
    await tester.pumpAndSettle();
    expect(find.text('Aucun résultat'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('search')), 'projet');
    await tester.pumpAndSettle();
    expect(find.text('Préparer le projet'), findsOneWidget);
  });
  testWidgets('completion filter reacts immediately', (tester) async {
    await mount(tester);
    await tap(tester, 'nav1');
    await tap(tester, 'toggle-a');
    await tap(tester, 'filter-completed');
    expect(find.text('Préparer le projet'), findsOneWidget);
    await tap(tester, 'filter-pending');
    expect(find.text('Préparer le projet'), findsNothing);
  });
  testWidgets('language switch translates navigation and content', (
    tester,
  ) async {
    await mount(tester);
    await tap(tester, 'nav3');
    await tap(tester, 'language-en');
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Dark mode'), findsOneWidget);
    await tap(tester, 'nav1');
    expect(find.text('Search tasks'), findsOneWidget);
  });
  testWidgets('dark mode changes app theme', (tester) async {
    final c = await mount(tester);
    await tap(tester, 'nav3');
    await tap(tester, 'darkMode');
    expect(c.snapshot.dark, isTrue);
    expect(
      Theme.of(tester.element(find.byType(SettingsScreen))).brightness,
      Brightness.dark,
    );
  });
  testWidgets('delete requires confirmation and cancel preserves data', (
    tester,
  ) async {
    final c = await mount(tester);
    await tap(tester, 'nav1');
    await tap(tester, 'task-a');
    await tap(tester, 'deleteTask');
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(c.tasks.length, 1);
    await tap(tester, 'deleteTask');
    await tap(tester, 'confirmDelete');
    expect(c.tasks, isEmpty);
    expect(find.byType(TaskDetailScreen), findsNothing);
  });
  testWidgets('storage failure keeps editor and user input', (tester) async {
    final r = MemoryRepository(AppSnapshot(tasks: []));
    await mount(tester, repository: r);
    r.failSave = true;
    await tap(tester, 'addTask');
    await tester.enterText(find.byKey(const Key('titleField')), 'À conserver');
    await tap(tester, 'saveTask');
    expect(find.byType(TaskEditorScreen), findsOneWidget);
    expect(find.text('À conserver'), findsOneWidget);
    expect(find.textContaining('Enregistrement impossible'), findsWidgets);
  });
  testWidgets('all navigation screens fit a 320px display at 200% text', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await mount(tester, size: const Size(320, 800));
    expect(tester.takeException(), isNull);
    for (final index in [1, 2, 3]) {
      await tap(tester, 'nav$index');
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('desktop navigation adapts without bottom bar', (tester) async {
    await mount(tester, size: const Size(1440, 1000));
    expect(find.byType(NavigationBar), findsNothing);
    await tap(tester, 'nav2');
    expect(find.text('Taux de réalisation'), findsOneWidget);
  });
  testWidgets('interactive targets have semantic labels and sufficient size', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await mount(tester);
    await tap(tester, 'nav1');
    expect(
      find.bySemanticsLabel('Terminer : Préparer le projet'),
      findsOneWidget,
    );
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    handle.dispose();
  });
  testWidgets('read failure displays retry and recovers', (tester) async {
    final r = MemoryRepository(AppSnapshot(tasks: []))..failLoad = true;
    await mount(tester, repository: r);
    expect(find.text('Réessayer'), findsOneWidget);
    r.failLoad = false;
    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();
    expect(
      find.text('Un peu de clarté,\nbeaucoup de possibilités.'),
      findsOneWidget,
    );
  });
}

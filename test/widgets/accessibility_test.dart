import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import '../helpers.dart';
import '../widget_harness.dart';

Future<void> checkAccessibility(WidgetTester tester) async {
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
  expect(tester.takeException(), isNull);
}

void main() {
  for (final language in ['fr', 'en']) {
    for (final dark in [false, true]) {
      testWidgets(
        'six screens expose labels, touch targets and contrast: $language / dark=$dark',
        (tester) async {
          final handle = tester.ensureSemantics();
          try {
            await mount(
              tester,
              repository: MemoryRepository(
                AppSnapshot(
                  tasks: [sampleTask()],
                  language: language,
                  dark: dark,
                ),
              ),
            );
            for (final index in [0, 1, 2, 3]) {
              await tap(tester, 'nav$index');
              await checkAccessibility(tester);
            }
            await tap(tester, 'nav1');
            await tap(tester, 'task-a');
            await checkAccessibility(tester);
            await tap(tester, 'editTask');
            await tester.ensureVisible(find.byKey(const Key('saveTask')));
            await checkAccessibility(tester);
          } finally {
            handle.dispose();
          }
        },
      );
    }
  }
  testWidgets('completion semantics changes from complete to reopen', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    try {
      await mount(tester);
      await tap(tester, 'nav1');
      expect(
        find.bySemanticsLabel('Terminer : Préparer le projet'),
        findsOneWidget,
      );
      await tap(tester, 'toggle-a');
      expect(
        find.bySemanticsLabel('Rouvrir : Préparer le projet'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Terminer : Préparer le projet'),
        findsNothing,
      );
    } finally {
      handle.dispose();
    }
  });
}

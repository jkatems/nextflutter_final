import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/data/preferences_repository.dart';
import 'package:focus_flow/domain/task.dart';
import 'package:focus_flow/state/app_controller.dart';
import 'package:focus_flow/ui/app.dart';

// Run on a physical Android/iOS device in profile mode, never use debug timings.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('profile a 1000-task list and export real frame timings', (
    tester,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final repository = PreferencesRepository(
      preferences: preferences,
      key: 'focusflow.performance-test.v1',
    );
    final original = await repository.load();
    try {
      await repository.save(
        AppSnapshot(
          tasks: List.generate(
            1000,
            (i) => Task(
              id: 'benchmark-$i',
              title: 'Task $i',
              category: TaskCategory.work,
              priority: TaskPriority.medium,
              dueDate: DateTime(2026, 9, 27),
            ),
          ),
        ),
      );
      final c = AppController(repository);
      await c.initialize();
      await tester.pumpWidget(FocusFlowApp(controller: c));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('nav1')));
      await tester.pumpAndSettle();
      final scroll = find.byType(CustomScrollView);
      // Warm-up avoids mixing initial shader/font work with steady-state scrolling.
      await tester.fling(scroll, const Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      await binding.watchPerformance(() async {
        for (var i = 0; i < 12; i++) {
          await tester.fling(scroll, Offset(0, i.isEven ? -600 : 600), 1200);
          await tester.pumpAndSettle();
        }
      }, reportKey: 'scroll_1000_tasks');
      final report =
          binding.reportData!['scroll_1000_tasks'] as Map<String, dynamic>;
      expect(report['frame_count'] as int, greaterThan(0));
      expect(
        report['99th_percentile_frame_build_time_millis'] as num,
        lessThan(16.67),
      );
      expect(
        report['99th_percentile_frame_rasterizer_time_millis'] as num,
        lessThan(16.67),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
    } finally {
      if (original != null) {
        await repository.save(original);
      } else {
        await preferences.remove(repository.key);
      }
    }
  });
}

import 'data/demo_snapshot.dart';
import 'data/preferences_repository.dart';
import 'domain/app_repository.dart';
import 'state/app_controller.dart';

/// Composition root: the only place that chooses production implementations.
/// Tests and other hosts can inject a repository and deterministic clock.
AppController createAppController({
  AppRepository? repository,
  DateTime Function()? clock,
}) => AppController(
  repository ?? PreferencesRepository(),
  clock: clock,
  initialSnapshot: demoSnapshot,
);

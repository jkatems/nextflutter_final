import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/data/preferences_repository.dart';
import '../helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('fresh storage returns null', () async {
    expect(
      await PreferencesRepository(
        preferences: await SharedPreferences.getInstance(),
      ).load(),
      isNull,
    );
  });
  test('real preferences adapter persists tasks and settings', () async {
    final prefs = await SharedPreferences.getInstance();
    final repository = PreferencesRepository(preferences: prefs);
    await repository.save(
      AppSnapshot(tasks: [sampleTask()], language: 'en', dark: true),
    );
    final restored = (await PreferencesRepository(preferences: prefs).load())!;
    expect(restored.language, 'en');
    expect(restored.dark, isTrue);
    expect(restored.tasks.single.toJson(), sampleTask().toJson());
  });
  test('empty list is preserved and does not reseed demo', () async {
    final repository = PreferencesRepository(
      preferences: await SharedPreferences.getInstance(),
    );
    await repository.save(AppSnapshot(tasks: []));
    expect((await repository.load())!.tasks, isEmpty);
  });
  test('corrupt persisted data raises without overwriting it', () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(PreferencesRepository.storageKey, 'not-json');
    await expectLater(
      PreferencesRepository(preferences: prefs).load(),
      throwsFormatException,
    );
    expect(prefs.getString(PreferencesRepository.storageKey), 'not-json');
  });
  test('unknown schema is rejected', () {
    expect(() => AppSnapshot.decode('{"schema":99}'), throwsFormatException);
  });
  test('duplicate task identifiers are rejected', () {
    expect(
      () => AppSnapshot.decode(
        jsonEncode({
          'schema': 1,
          'language': 'fr',
          'dark': false,
          'tasks': [sampleTask().toJson(), sampleTask().toJson()],
        }),
      ),
      throwsFormatException,
    );
  });
  test('snapshot list cannot be externally mutated', () {
    final original = [sampleTask()];
    final snapshot = AppSnapshot(tasks: original);
    original.clear();
    expect(snapshot.tasks.length, 1);
    expect(() => snapshot.tasks.clear(), throwsUnsupportedError);
  });
}

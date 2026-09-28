import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_flow/domain/app_snapshot.dart';
import 'package:focus_flow/data/preferences_repository.dart';
import '../helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('integration and benchmark storage never overwrite user data', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final production = PreferencesRepository(preferences: prefs);
    final isolated = PreferencesRepository(
      preferences: prefs,
      key: 'focusflow.test.v1',
    );
    await production.save(AppSnapshot(tasks: [sampleTask()]));
    await isolated.save(AppSnapshot(tasks: []));
    expect((await production.load())!.tasks.single.id, 'a');
    expect((await isolated.load())!.tasks, isEmpty);
    await prefs.remove(isolated.key);
    expect((await production.load())!.tasks.single.id, 'a');
  });
}

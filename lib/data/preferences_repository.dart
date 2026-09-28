import 'package:shared_preferences/shared_preferences.dart';
import '../domain/app_repository.dart';
import '../domain/app_snapshot.dart';

/// SharedPreferences adapter; accepts a separate key for isolated test runs.
class PreferencesRepository implements AppRepository {
  PreferencesRepository({this.preferences, this.key = storageKey});
  static const storageKey = 'focusflow.snapshot.v1';
  final SharedPreferences? preferences;
  final String key;
  @override
  Future<AppSnapshot?> load() async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    return raw == null ? null : AppSnapshot.decode(raw);
  }

  @override
  Future<void> save(AppSnapshot snapshot) async {
    final prefs = preferences ?? await SharedPreferences.getInstance();
    if (!await prefs.setString(key, snapshot.encode())) {
      throw StateError('Storage unavailable');
    }
  }
}

import 'app_snapshot.dart';

/// Persistence port. Implementations must report failed writes by throwing.
abstract interface class AppRepository {
  Future<AppSnapshot?> load();
  Future<void> save(AppSnapshot snapshot);
}

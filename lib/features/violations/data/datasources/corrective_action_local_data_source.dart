import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/violations/data/mappers/corrective_action_mapper.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';

abstract class CorrectiveActionLocalDataSource {
  Future<void> saveAction(CorrectiveAction action);
  Future<void> updateAction(CorrectiveAction action);
  Future<List<CorrectiveAction>> getActionsForViolation(String violationId);
  Future<CorrectiveAction?> getActionById(String localId);
  Future<T> transaction<T>(Future<T> Function() action);
}

class CorrectiveActionLocalDataSourceImpl implements CorrectiveActionLocalDataSource {
  final AppDatabase _db;

  CorrectiveActionLocalDataSourceImpl(this._db);

  @override
  Future<void> saveAction(CorrectiveAction action) async {
    await _db.into(_db.correctiveActions).insert(CorrectiveActionMapper.toCompanion(action));
  }

  @override
  Future<void> updateAction(CorrectiveAction action) async {
    final query = _db.update(_db.correctiveActions)
      ..where((t) => t.localId.equals(action.localId));
    
    await query.write(CorrectiveActionMapper.toCompanion(action));
  }

  @override
  Future<List<CorrectiveAction>> getActionsForViolation(String violationId) async {
    final query = _db.select(_db.correctiveActions)
      ..where((t) => t.violationId.equals(violationId));
    final results = await query.get();
    return results.map(CorrectiveActionMapper.toDomain).toList();
  }

  @override
  Future<CorrectiveAction?> getActionById(String localId) async {
    final query = _db.select(_db.correctiveActions)..where((t) => t.localId.equals(localId));
    final result = await query.getSingleOrNull();
    return result != null ? CorrectiveActionMapper.toDomain(result) : null;
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return _db.transaction(action);
  }
}

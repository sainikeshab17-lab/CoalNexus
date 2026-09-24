import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/data/mappers/violation_mapper.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';

abstract class ViolationLocalDataSource {
  Future<List<ViolationModel>> getCachedViolations();
  Future<ViolationModel?> getViolationById(String id);
  Future<List<ViolationModel>> searchViolations(String query);
  Future<List<ViolationModel>> getViolationsForMine(String mineId);
  Future<List<ViolationModel>> getViolationsForInspection(String inspectionId);
  Future<void> saveViolation(Violation violation, {int localVersion = 1});
  Future<void> updateViolation(Violation violation, {int? expectedVersion});
  Future<void> deleteViolation(String id);
  Future<void> clearAllViolations();
  Future<T> transaction<T>(Future<T> Function() action);
}

class ViolationLocalDataSourceImpl implements ViolationLocalDataSource {
  final AppDatabase _database;

  ViolationLocalDataSourceImpl(this._database);

  @override
  Future<List<ViolationModel>> getCachedViolations() async {
    final rows = await _database.select(_database.violations).get();
    return rows.map((row) => ViolationMapper.fromEntity(row)).toList();
  }

  @override
  Future<ViolationModel?> getViolationById(String id) async {
    final query = _database.select(_database.violations)..where((t) => t.localId.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return ViolationMapper.fromEntity(row);
  }

  @override
  Future<List<ViolationModel>> searchViolations(String query) async {
    final searchPattern = '%$query%';
    final dbQuery = _database.select(_database.violations)
      ..where((t) => t.title.like(searchPattern) | t.description.like(searchPattern));
    final rows = await dbQuery.get();
    return rows.map((row) => ViolationMapper.fromEntity(row)).toList();
  }

  @override
  Future<List<ViolationModel>> getViolationsForMine(String mineId) async {
    final query = _database.select(_database.violations)..where((t) => t.mineId.equals(mineId));
    final rows = await query.get();
    return rows.map((row) => ViolationMapper.fromEntity(row)).toList();
  }

  @override
  Future<List<ViolationModel>> getViolationsForInspection(String inspectionId) async {
    final query = _database.select(_database.violations)..where((t) => t.inspectionId.equals(inspectionId));
    final rows = await query.get();
    return rows.map((row) => ViolationMapper.fromEntity(row)).toList();
  }

  @override
  Future<void> saveViolation(Violation violation, {int localVersion = 1}) async {
    final entity = ViolationMapper.toEntity(violation, localVersion: localVersion);
    await _database.into(_database.violations).insert(entity);
  }

  @override
  Future<void> updateViolation(Violation violation, {int? expectedVersion}) async {
    final query = _database.update(_database.violations)
      ..where((t) => t.localId.equals(violation.localId));

    if (expectedVersion != null) {
      query.where((t) => t.localVersion.equals(expectedVersion));
    }

    final entity = ViolationMapper.toEntity(violation);
    final updatedRows = await query.write(
      ViolationsCompanion(
        title: Value(entity.title),
        description: Value(entity.description),
        severity: Value(entity.severity),
        status: Value(entity.status),
        assignedTo: Value(entity.assignedTo),
        dueDate: Value(entity.dueDate),
        updatedAt: Value(entity.updatedAt),
        localVersion: Value(entity.localVersion),
        serverId: Value(entity.serverId),
      ),
    );

    if (updatedRows == 0) {
      throw Exception('Update failed: Violation not found or version mismatch');
    }
  }

  @override
  Future<void> deleteViolation(String id) async {
    await (_database.delete(_database.violations)..where((t) => t.localId.equals(id))).go();
  }

  @override
  Future<void> clearAllViolations() async {
    await _database.delete(_database.violations).go();
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return _database.transaction(action);
  }
}

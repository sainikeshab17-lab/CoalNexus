import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/inspections/data/mappers/inspection_mapper.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';

abstract class InspectionLocalDataSource {
  Future<void> saveInspection(Inspection inspection);
  Future<void> updateInspection(Inspection inspection);
  Future<List<Inspection>> getAllInspections();
  Future<Inspection?> getInspectionById(String id);
  Future<void> saveFinding(InspectionFinding finding);
  Future<List<InspectionFinding>> getFindingsForInspection(String inspectionId);
  Future<T> transaction<T>(Future<T> Function() action);
}

class InspectionLocalDataSourceImpl implements InspectionLocalDataSource {
  final AppDatabase _db;

  InspectionLocalDataSourceImpl(this._db);

  @override
  Future<void> saveInspection(Inspection inspection) async {
    await _db.into(_db.inspections).insert(InspectionMapper.toCompanion(inspection));
  }

  @override
  Future<void> updateInspection(Inspection inspection) async {
    final query = _db.update(_db.inspections)
      ..where((t) => t.localId.equals(inspection.localId))
      ..where((t) => t.localVersion.equals(inspection.localVersion - 1));
    
    final updatedRows = await query.write(
      InspectionsCompanion(
        serverId: Value(inspection.serverId),
        status: Value(inspection.status),
        updatedAt: Value(inspection.updatedAt),
        localVersion: Value(inspection.localVersion),
      ),
    );

    if (updatedRows == 0) {
      throw Exception('Update failed: Inspection not found or version mismatch');
    }
  }

  @override
  Future<List<Inspection>> getAllInspections() async {
    final results = await _db.select(_db.inspections).get();
    return results.map(InspectionMapper.toDomain).toList();
  }

  @override
  Future<Inspection?> getInspectionById(String id) async {
    final query = _db.select(_db.inspections)..where((t) => t.localId.equals(id));
    final result = await query.getSingleOrNull();
    return result != null ? InspectionMapper.toDomain(result) : null;
  }

  @override
  Future<void> saveFinding(InspectionFinding finding) async {
    await _db.into(_db.inspectionFindings).insert(InspectionMapper.findingToCompanion(finding));
  }

  @override
  Future<List<InspectionFinding>> getFindingsForInspection(String inspectionId) async {
    final query = _db.select(_db.inspectionFindings)
      ..where((t) => t.inspectionId.equals(inspectionId));
    final results = await query.get();
    return results.map(InspectionMapper.findingToDomain).toList();
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return _db.transaction(action);
  }
}

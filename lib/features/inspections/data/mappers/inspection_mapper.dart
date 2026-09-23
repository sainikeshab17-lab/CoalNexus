import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';

class InspectionMapper {
  static Inspection toDomain(InspectionEntity entity) {
    return Inspection(
      localId: entity.localId,
      serverId: entity.serverId,
      mineId: entity.mineId,
      inspectorId: entity.inspectorId,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      localVersion: entity.localVersion,
    );
  }

  static InspectionsCompanion toCompanion(Inspection inspection) {
    return InspectionsCompanion.insert(
      localId: inspection.localId,
      serverId: Value(inspection.serverId),
      mineId: inspection.mineId,
      inspectorId: inspection.inspectorId,
      status: inspection.status,
      createdAt: Value(inspection.createdAt),
      updatedAt: Value(inspection.updatedAt),
      localVersion: Value(inspection.localVersion),
    );
  }

  static InspectionFinding findingToDomain(InspectionFindingEntity entity) {
    return InspectionFinding(
      localId: entity.localId,
      serverId: entity.serverId,
      inspectionId: entity.inspectionId,
      requirementId: entity.requirementId,
      description: entity.description,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      localVersion: entity.localVersion,
    );
  }

  static InspectionFindingsCompanion findingToCompanion(InspectionFinding finding) {
    return InspectionFindingsCompanion.insert(
      localId: finding.localId,
      serverId: Value(finding.serverId),
      inspectionId: finding.inspectionId,
      requirementId: finding.requirementId,
      description: finding.description,
      status: finding.status,
      createdAt: Value(finding.createdAt),
      updatedAt: Value(finding.updatedAt),
      localVersion: Value(finding.localVersion),
    );
  }
}

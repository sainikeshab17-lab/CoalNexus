import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';

class ViolationMapper {
  static ViolationModel fromEntity(ViolationEntity entity) {
    return ViolationModel(
      localId: entity.localId,
      serverId: entity.serverId,
      inspectionId: entity.inspectionId,
      findingId: entity.findingId,
      mineId: entity.mineId,
      title: entity.title,
      description: entity.description,
      severity: entity.severity,
      status: entity.status,
      assignedTo: entity.assignedTo,
      dueDate: entity.dueDate,
      detectedAt: entity.detectedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      localVersion: entity.localVersion,
    );
  }

  static ViolationEntity toEntity(Violation violation, {int? localVersion}) {
    return ViolationEntity(
      localId: violation.localId,
      serverId: violation.serverId,
      inspectionId: violation.inspectionId,
      findingId: violation.findingId,
      mineId: violation.mineId,
      title: violation.title,
      description: violation.description,
      severity: violation.severity,
      status: violation.status,
      assignedTo: violation.assignedTo,
      dueDate: violation.dueDate,
      detectedAt: violation.detectedAt,
      createdAt: violation.createdAt,
      updatedAt: violation.updatedAt,
      localVersion: localVersion ?? violation.localVersion,
    );
  }

  static Violation toDomain(ViolationModel model) {
    return model.toDomain();
  }
}

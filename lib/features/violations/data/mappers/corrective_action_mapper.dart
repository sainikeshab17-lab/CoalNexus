import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';

class CorrectiveActionMapper {
  static CorrectiveAction toDomain(CorrectiveActionEntity entity) {
    return CorrectiveAction(
      localId: entity.localId,
      serverId: entity.serverId,
      violationId: entity.violationId,
      title: entity.title,
      description: entity.description,
      assignedTo: entity.assignedTo,
      priority: entity.priority,
      dueDate: entity.dueDate,
      status: entity.status,
      submittedAt: entity.submittedAt,
      verifiedAt: entity.verifiedAt,
      evidence: entity.evidence,
      localVersion: entity.localVersion,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static CorrectiveActionsCompanion toCompanion(CorrectiveAction domain) {
    return CorrectiveActionsCompanion.insert(
      localId: domain.localId,
      serverId: Value(domain.serverId),
      violationId: domain.violationId,
      title: domain.title,
      description: domain.description,
      assignedTo: domain.assignedTo,
      priority: domain.priority,
      dueDate: domain.dueDate,
      status: domain.status,
      submittedAt: Value(domain.submittedAt),
      verifiedAt: Value(domain.verifiedAt),
      evidence: Value(domain.evidence),
      localVersion: Value(domain.localVersion),
      createdAt: Value(domain.createdAt),
      updatedAt: Value(domain.updatedAt),
    );
  }
}

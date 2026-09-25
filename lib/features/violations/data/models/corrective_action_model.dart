import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';

class CorrectiveActionModel {
  final String localId;
  final String? serverId;
  final String violationId;
  final String title;
  final String description;
  final String assignedTo;
  final String priority;
  final String dueDate;
  final String status;
  final String? submittedAt;
  final String? verifiedAt;
  final String? evidence;
  final int localVersion;
  final String createdAt;
  final String updatedAt;

  const CorrectiveActionModel({
    required this.localId,
    this.serverId,
    required this.violationId,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.dueDate,
    required this.status,
    this.submittedAt,
    this.verifiedAt,
    this.evidence,
    required this.localVersion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CorrectiveActionModel.fromDomain(CorrectiveAction domain) {
    return CorrectiveActionModel(
      localId: domain.localId,
      serverId: domain.serverId,
      violationId: domain.violationId,
      title: domain.title,
      description: domain.description,
      assignedTo: domain.assignedTo,
      priority: domain.priority,
      dueDate: domain.dueDate.toIso8601String(),
      status: domain.status.name,
      submittedAt: domain.submittedAt?.toIso8601String(),
      verifiedAt: domain.verifiedAt?.toIso8601String(),
      evidence: domain.evidence,
      localVersion: domain.localVersion,
      createdAt: domain.createdAt.toIso8601String(),
      updatedAt: domain.updatedAt.toIso8601String(),
    );
  }

  CorrectiveAction toDomain() {
    return CorrectiveAction(
      localId: localId,
      serverId: serverId,
      violationId: violationId,
      title: title,
      description: description,
      assignedTo: assignedTo,
      priority: priority,
      dueDate: DateTime.parse(dueDate),
      status: CorrectiveActionStatus.values.firstWhere((e) => e.name == status),
      submittedAt: submittedAt != null ? DateTime.parse(submittedAt!) : null,
      verifiedAt: verifiedAt != null ? DateTime.parse(verifiedAt!) : null,
      evidence: evidence,
      localVersion: localVersion,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'server_id': serverId,
      'violation_id': violationId,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'priority': priority,
      'due_date': dueDate,
      'status': status,
      'submitted_at': submittedAt,
      'verified_at': verifiedAt,
      'evidence': evidence,
      'local_version': localVersion,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CorrectiveActionModel.fromJson(Map<String, dynamic> json) {
    return CorrectiveActionModel(
      localId: (json['local_id'] ?? json['localId']) as String,
      serverId: (json['server_id'] ?? json['id'] ?? json['serverId']) as String?,
      violationId: (json['violation_id'] ?? json['violationId']) as String,
      title: json['title'] as String,
      description: json['description'] as String,
      assignedTo: (json['assigned_to'] ?? json['assignedTo']) as String,
      priority: json['priority'] as String,
      dueDate: (json['due_date'] ?? json['dueDate']) as String,
      status: json['status'] as String,
      submittedAt: (json['submitted_at'] ?? json['submittedAt']) as String?,
      verifiedAt: (json['verified_at'] ?? json['verifiedAt']) as String?,
      evidence: json['evidence'] as String?,
      localVersion: (json['local_version'] ?? json['localVersion']) as int,
      createdAt: (json['created_at'] ?? json['createdAt']) as String,
      updatedAt: (json['updated_at'] ?? json['updatedAt']) as String,
    );
  }
}

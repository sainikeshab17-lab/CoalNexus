import 'package:coalnexus/features/violations/domain/entities/violation.dart';

class ViolationModel extends Violation {
  const ViolationModel({
    required super.localId,
    super.serverId,
    required super.inspectionId,
    required super.findingId,
    required super.mineId,
    required super.title,
    required super.description,
    required super.severity,
    required super.status,
    super.assignedTo,
    super.dueDate,
    required super.detectedAt,
    required super.createdAt,
    required super.updatedAt,
    super.localVersion = 1,
  });

  factory ViolationModel.fromDomain(Violation violation, {int? localVersion}) {
    return ViolationModel(
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

  Violation toDomain() {
    return Violation(
      localId: localId,
      serverId: serverId,
      inspectionId: inspectionId,
      findingId: findingId,
      mineId: mineId,
      title: title,
      description: description,
      severity: severity,
      status: status,
      assignedTo: assignedTo,
      dueDate: dueDate,
      detectedAt: detectedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'serverId': serverId,
      'inspectionId': inspectionId,
      'findingId': findingId,
      'mineId': mineId,
      'title': title,
      'description': description,
      'severity': severity.name,
      'status': status.name,
      'assignedTo': assignedTo,
      'dueDate': dueDate?.toIso8601String(),
      'detectedAt': detectedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'localVersion': localVersion,
    };
  }

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      localId: json['localId'] as String,
      serverId: json['serverId'] as String?,
      inspectionId: json['inspectionId'] as String,
      findingId: json['findingId'] as String,
      mineId: json['mineId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: ViolationSeverity.values.firstWhere((e) => e.name == json['severity']),
      status: ViolationStatus.values.firstWhere((e) => e.name == json['status']),
      assignedTo: json['assignedTo'] as String?,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      detectedAt: DateTime.parse(json['detectedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      localVersion: json['localVersion'] as int,
    );
  }
}

import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';

class InspectionFindingModel {
  final String localId;
  final String? serverId;
  final String inspectionId;
  final String requirementId;
  final String description;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int localVersion;

  const InspectionFindingModel({
    required this.localId,
    this.serverId,
    required this.inspectionId,
    required this.requirementId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });

  factory InspectionFindingModel.fromDomain(InspectionFinding finding) {
    return InspectionFindingModel(
      localId: finding.localId,
      serverId: finding.serverId,
      inspectionId: finding.inspectionId,
      requirementId: finding.requirementId,
      description: finding.description,
      status: finding.status.name,
      createdAt: finding.createdAt.toIso8601String(),
      updatedAt: finding.updatedAt.toIso8601String(),
      localVersion: finding.localVersion,
    );
  }

  InspectionFinding toDomain() {
    return InspectionFinding(
      localId: localId,
      serverId: serverId,
      inspectionId: inspectionId,
      requirementId: requirementId,
      description: description,
      status: FindingStatus.values.firstWhere((e) => e.name == status),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'server_id': serverId,
      'inspection_id': inspectionId,
      'requirement_id': requirementId,
      'description': description,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'local_version': localVersion,
    };
  }

  factory InspectionFindingModel.fromJson(Map<String, dynamic> json) {
    return InspectionFindingModel(
      localId: (json['local_id'] ?? json['localId']) as String,
      serverId: (json['server_id'] ?? json['id'] ?? json['serverId']) as String?,
      inspectionId: (json['inspection_id'] ?? json['inspectionId']) as String,
      requirementId: (json['requirement_id'] ?? json['requirementId']) as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: (json['created_at'] ?? json['createdAt']) as String,
      updatedAt: (json['updated_at'] ?? json['updatedAt']) as String,
      localVersion: (json['local_version'] ?? json['localVersion']) as int,
    );
  }
}

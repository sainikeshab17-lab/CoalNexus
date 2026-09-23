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
      'localId': localId,
      'serverId': serverId,
      'inspectionId': inspectionId,
      'requirementId': requirementId,
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'localVersion': localVersion,
    };
  }

  factory InspectionFindingModel.fromJson(Map<String, dynamic> json) {
    return InspectionFindingModel(
      localId: json['localId'] as String,
      serverId: json['serverId'] as String?,
      inspectionId: json['inspectionId'] as String,
      requirementId: json['requirementId'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      localVersion: json['localVersion'] as int,
    );
  }
}

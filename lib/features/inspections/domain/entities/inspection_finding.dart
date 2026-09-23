import 'package:flutter/foundation.dart';

enum FindingStatus {
  compliant,
  nonCompliant,
  notApplicable,
}

@immutable
class InspectionFinding {
  final String localId;
  final String? serverId;
  final String inspectionId;
  final String requirementId;
  final String description;
  final FindingStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;

  const InspectionFinding({
    required this.localId,
    this.serverId,
    required this.inspectionId,
    required this.requirementId,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.localVersion = 1,
  });

  InspectionFinding copyWith({
    String? localId,
    String? serverId,
    String? inspectionId,
    String? requirementId,
    String? description,
    FindingStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) {
    return InspectionFinding(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      inspectionId: inspectionId ?? this.inspectionId,
      requirementId: requirementId ?? this.requirementId,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InspectionFinding &&
          runtimeType == other.runtimeType &&
          localId == other.localId &&
          serverId == other.serverId &&
          inspectionId == other.inspectionId &&
          requirementId == other.requirementId &&
          description == other.description &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          localVersion == other.localVersion;

  @override
  int get hashCode =>
      localId.hashCode ^
      serverId.hashCode ^
      inspectionId.hashCode ^
      requirementId.hashCode ^
      description.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      localVersion.hashCode;
}

import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';

class InspectionModel {
  final String localId;
  final String? serverId;
  final String mineId;
  final String inspectorId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int localVersion;

  const InspectionModel({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.inspectorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.localVersion,
  });

  factory InspectionModel.fromDomain(Inspection inspection) {
    return InspectionModel(
      localId: inspection.localId,
      serverId: inspection.serverId,
      mineId: inspection.mineId,
      inspectorId: inspection.inspectorId,
      status: inspection.status.name,
      createdAt: inspection.createdAt.toIso8601String(),
      updatedAt: inspection.updatedAt.toIso8601String(),
      localVersion: inspection.localVersion,
    );
  }

  Inspection toDomain() {
    return Inspection(
      localId: localId,
      serverId: serverId,
      mineId: mineId,
      inspectorId: inspectorId,
      status: InspectionStatus.values.firstWhere((e) => e.name == status),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'server_id': serverId,
      'mine_id': mineId,
      'inspector_id': inspectorId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'local_version': localVersion,
    };
  }

  factory InspectionModel.fromJson(Map<String, dynamic> json) {
    return InspectionModel(
      localId: (json['local_id'] ?? json['localId']) as String,
      serverId: (json['server_id'] ?? json['id'] ?? json['serverId']) as String?,
      mineId: (json['mine_id'] ?? json['mineId']) as String,
      inspectorId: (json['inspector_id'] ?? json['inspectorId']) as String,
      status: json['status'] as String,
      createdAt: (json['created_at'] ?? json['createdAt']) as String,
      updatedAt: (json['updated_at'] ?? json['updatedAt']) as String,
      localVersion: (json['local_version'] ?? json['localVersion']) as int,
    );
  }
}

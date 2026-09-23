import 'package:flutter/foundation.dart';

enum InspectionStatus {
  draft,
  completed,
  submitted,
}

@immutable
class Inspection {
  final String localId;
  final String? serverId;
  final String mineId;
  final String inspectorId;
  final InspectionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int localVersion;

  const Inspection({
    required this.localId,
    this.serverId,
    required this.mineId,
    required this.inspectorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.localVersion = 1,
  });

  Inspection copyWith({
    String? localId,
    String? serverId,
    String? mineId,
    String? inspectorId,
    InspectionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) {
    return Inspection(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      mineId: mineId ?? this.mineId,
      inspectorId: inspectorId ?? this.inspectorId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Inspection &&
          runtimeType == other.runtimeType &&
          localId == other.localId &&
          serverId == other.serverId &&
          mineId == other.mineId &&
          inspectorId == other.inspectorId &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          localVersion == other.localVersion;

  @override
  int get hashCode =>
      localId.hashCode ^
      serverId.hashCode ^
      mineId.hashCode ^
      inspectorId.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      localVersion.hashCode;
}

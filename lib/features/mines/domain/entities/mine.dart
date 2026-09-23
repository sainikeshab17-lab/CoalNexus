import 'package:flutter/foundation.dart';

enum MineStatus {
  active,
  inactive,
  suspended,
  underMaintenance,
}

@immutable
class Mine {
  final String localId;
  final String? serverId;
  final String name;
  final String mineCode;
  final double latitude;
  final double longitude;
  final MineStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Mine({
    required this.localId,
    this.serverId,
    required this.name,
    required this.mineCode,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Mine &&
          runtimeType == other.runtimeType &&
          localId == other.localId &&
          serverId == other.serverId &&
          name == other.name &&
          mineCode == other.mineCode &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          status == other.status &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      localId.hashCode ^
      serverId.hashCode ^
      name.hashCode ^
      mineCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

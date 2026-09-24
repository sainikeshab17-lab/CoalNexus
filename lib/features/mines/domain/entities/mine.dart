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
  final int localVersion;

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
    this.localVersion = 1,
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
          updatedAt == other.updatedAt &&
          localVersion == other.localVersion;

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
      updatedAt.hashCode ^
      localVersion.hashCode;

  Mine copyWith({
    String? localId,
    String? serverId,
    String? name,
    String? mineCode,
    double? latitude,
    double? longitude,
    MineStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? localVersion,
  }) {
    return Mine(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      mineCode: mineCode ?? this.mineCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
    );
  }
}

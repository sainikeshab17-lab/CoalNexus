import 'package:flutter/foundation.dart';

enum MineStatus { active, inactive, suspended, underMaintenance }

@immutable
class Mine {
  final String localId;
  final String? serverId;
  final String name;
  final String mineCode;
  final double latitude;
  final double longitude;
  final MineStatus status;
  final String? company;
  final String? district;
  final String? state;
  final String? ownerCode;
  final String? ownerName;
  final String? ownershipType;
  final String? commodity;
  final String? mineType;
  final double? productionHist;
  final String? coordinateAccuracy;
  final String? source;
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
    this.company,
    this.district,
    this.state,
    this.ownerCode,
    this.ownerName,
    this.ownershipType,
    this.commodity,
    this.mineType,
    this.productionHist,
    this.coordinateAccuracy,
    this.source,
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
          company == other.company &&
          district == other.district &&
          state == other.state &&
          ownerCode == other.ownerCode &&
          ownerName == other.ownerName &&
          ownershipType == other.ownershipType &&
          commodity == other.commodity &&
          mineType == other.mineType &&
          productionHist == other.productionHist &&
          coordinateAccuracy == other.coordinateAccuracy &&
          source == other.source &&
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
      company.hashCode ^
      district.hashCode ^
      state.hashCode ^
      ownerCode.hashCode ^
      ownerName.hashCode ^
      ownershipType.hashCode ^
      commodity.hashCode ^
      mineType.hashCode ^
      productionHist.hashCode ^
      coordinateAccuracy.hashCode ^
      source.hashCode ^
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
    String? company,
    String? district,
    String? state,
    String? ownerCode,
    String? ownerName,
    String? ownershipType,
    String? commodity,
    String? mineType,
    double? productionHist,
    String? coordinateAccuracy,
    String? source,
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
      company: company ?? this.company,
      district: district ?? this.district,
      state: state ?? this.state,
      ownerCode: ownerCode ?? this.ownerCode,
      ownerName: ownerName ?? this.ownerName,
      ownershipType: ownershipType ?? this.ownershipType,
      commodity: commodity ?? this.commodity,
      mineType: mineType ?? this.mineType,
      productionHist: productionHist ?? this.productionHist,
      coordinateAccuracy: coordinateAccuracy ?? this.coordinateAccuracy,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localVersion: localVersion ?? this.localVersion,
    );
  }
}

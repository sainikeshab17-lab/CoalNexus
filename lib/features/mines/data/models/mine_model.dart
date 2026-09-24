import 'package:coalnexus/features/mines/domain/entities/mine.dart';

class MineModel extends Mine {
  const MineModel({
    required super.localId,
    super.serverId,
    required super.name,
    required super.mineCode,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.localVersion = 1,
  });

  factory MineModel.fromDomain(Mine mine, {int? localVersion}) {
    return MineModel(
      localId: mine.localId,
      serverId: mine.serverId,
      name: mine.name,
      mineCode: mine.mineCode,
      latitude: mine.latitude,
      longitude: mine.longitude,
      status: mine.status,
      createdAt: mine.createdAt,
      updatedAt: mine.updatedAt,
      localVersion: localVersion ?? mine.localVersion,
    );
  }

  Mine toDomain() {
    return Mine(
      localId: localId,
      serverId: serverId,
      name: name,
      mineCode: mineCode,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      localVersion: localVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'serverId': serverId,
      'name': name,
      'mineCode': mineCode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'localVersion': localVersion,
    };
  }

  factory MineModel.fromJson(Map<String, dynamic> json) {
    return MineModel(
      localId: json['localId'] as String,
      serverId: json['serverId'] as String?,
      name: json['name'] as String,
      mineCode: json['mineCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: MineStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      localVersion: json['localVersion'] as int,
    );
  }
}

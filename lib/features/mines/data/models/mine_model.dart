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
      'local_id': localId,
      'server_id': serverId,
      'name': name,
      'mine_code': mineCode,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'local_version': localVersion,
    };
  }

  factory MineModel.fromJson(Map<String, dynamic> json) {
    return MineModel(
      localId: json['local_id'] ?? json['localId'] as String,
      serverId: (json['id'] ?? json['serverId']) as String?,
      name: json['name'] as String,
      mineCode: json['mine_code'] ?? json['mineCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: MineStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse((json['created_at'] ?? json['createdAt']) as String),
      updatedAt: DateTime.parse((json['updated_at'] ?? json['updatedAt']) as String),
      localVersion: (json['local_version'] ?? json['localVersion']) as int,
    );
  }
}

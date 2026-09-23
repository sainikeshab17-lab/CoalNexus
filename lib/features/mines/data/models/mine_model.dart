import 'package:coalnexus/features/mines/domain/entities/mine.dart';

class MineModel extends Mine {
  final int localVersion;

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
    this.localVersion = 1,
  });

  factory MineModel.fromDomain(Mine mine, {int localVersion = 1}) {
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
      localVersion: localVersion,
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
    );
  }
}

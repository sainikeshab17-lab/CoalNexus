import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/mines/data/models/mine_model.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';

class MineMapper {
  static MineModel fromEntity(MineEntity entity) {
    return MineModel(
      localId: entity.localId,
      serverId: entity.serverId,
      name: entity.name,
      mineCode: entity.mineCode,
      latitude: entity.latitude,
      longitude: entity.longitude,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      localVersion: entity.localVersion,
    );
  }

  static MineEntity toEntity(Mine mine, {int? localVersion}) {
    return MineEntity(
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

  static Mine toDomain(MineModel model) {
    return model.toDomain();
  }
}

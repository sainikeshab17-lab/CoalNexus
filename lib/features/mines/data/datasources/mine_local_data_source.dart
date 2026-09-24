import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/mines/data/models/mine_model.dart';
import 'package:coalnexus/features/mines/data/mappers/mine_mapper.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';

abstract class MineLocalDataSource {
  Future<List<MineModel>> getCachedMines();
  Future<MineModel?> getMineById(String id);
  Future<List<MineModel>> searchMines(String query);
  Future<void> saveMine(Mine mine, {int localVersion = 1});
  Future<void> updateMine(Mine mine, {int? expectedVersion});
  Future<void> deleteMine(String id);
  Future<void> clearAllMines();
  Future<T> transaction<T>(Future<T> Function() action);
}

class MineLocalDataSourceImpl implements MineLocalDataSource {
  final AppDatabase _database;

  MineLocalDataSourceImpl(this._database);

  @override
  Future<List<MineModel>> getCachedMines() async {
    final rows = await _database.select(_database.mines).get();
    return rows.map((row) => MineMapper.fromEntity(row)).toList();
  }

  @override
  Future<MineModel?> getMineById(String id) async {
    final query = _database.select(_database.mines)..where((t) => t.localId.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return MineMapper.fromEntity(row);
  }

  @override
  Future<List<MineModel>> searchMines(String query) async {
    final searchPattern = '%$query%';
    final dbQuery = _database.select(_database.mines)
      ..where((t) => t.name.like(searchPattern) | t.mineCode.like(searchPattern));
    final rows = await dbQuery.get();
    return rows.map((row) => MineMapper.fromEntity(row)).toList();
  }

  @override
  Future<void> saveMine(Mine mine, {int localVersion = 1}) async {
    final entity = MineMapper.toEntity(mine, localVersion: localVersion);
    await _database.into(_database.mines).insert(entity);
  }

  @override
  Future<void> updateMine(Mine mine, {int? expectedVersion}) async {
    final query = _database.update(_database.mines)
      ..where((t) => t.localId.equals(mine.localId));
    
    if (expectedVersion != null) {
      query.where((t) => t.localVersion.equals(expectedVersion));
    }

    final entity = MineMapper.toEntity(mine);
    final updatedRows = await query.write(
      MinesCompanion(
        name: Value(entity.name),
        mineCode: Value(entity.mineCode),
        latitude: Value(entity.latitude),
        longitude: Value(entity.longitude),
        status: Value(entity.status),
        updatedAt: Value(entity.updatedAt),
        localVersion: Value(entity.localVersion),
        serverId: Value(entity.serverId),
      ),
    );

    if (updatedRows == 0) {
      throw Exception('Update failed: Mine not found or version mismatch');
    }
  }

  @override
  Future<void> deleteMine(String id) async {
    await (_database.delete(_database.mines)..where((t) => t.localId.equals(id))).go();
  }

  @override
  Future<void> clearAllMines() async {
    await _database.delete(_database.mines).go();
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return _database.transaction(action);
  }
}

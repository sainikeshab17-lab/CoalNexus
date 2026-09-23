import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class MineRepositoryImpl implements MineRepository {
  final MineLocalDataSource _localDataSource;

  MineRepositoryImpl(this._localDataSource);

  @override
  Future<List<Mine>> getCachedMines() async {
    final models = await _localDataSource.getCachedMines();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Mine?> getMineById(String id) async {
    final model = await _localDataSource.getMineById(id);
    return model?.toDomain();
  }

  @override
  Future<List<Mine>> searchMines(String query) async {
    final models = await _localDataSource.searchMines(query);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> refreshMines() async {
    // Remote API is not implemented yet. This acts as a placeholder boundary.
    return;
  }

  @override
  Future<void> saveMine(Mine mine) async {
    await _localDataSource.saveMine(mine);
  }

  @override
  Future<void> deleteMine(String id) async {
    await _localDataSource.deleteMine(id);
  }
}

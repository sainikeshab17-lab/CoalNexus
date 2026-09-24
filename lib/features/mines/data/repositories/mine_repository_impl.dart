import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/data/models/mine_model.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/domain/repositories/mine_repository.dart';

class MineRepositoryImpl implements MineRepository {
  final MineLocalDataSource _localDataSource;
  final OutboxService _outboxService;

  MineRepositoryImpl(this._localDataSource, this._outboxService);

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
  Future<void> createMine(Mine mine) async {
    await _localDataSource.transaction(() async {
      await _localDataSource.saveMine(mine);

      final model = MineModel.fromDomain(mine);
      await _outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'CREATE_MINE',
        payloadJson: jsonEncode(model.toJson()),
        localId: mine.localId,
      );
    });
  }

  @override
  Future<void> updateMine(Mine mine) async {
    await _localDataSource.transaction(() async {
      // Fetch existing to get current version for optimistic locking
      final existing = await _localDataSource.getMineById(mine.localId);
      final currentVersion = existing?.localVersion ?? 1;
      final nextVersion = currentVersion + 1;

      await _localDataSource.updateMine(mine, expectedVersion: currentVersion);

      final model = MineModel.fromDomain(mine, localVersion: nextVersion);
      await _outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'UPDATE_MINE',
        payloadJson: jsonEncode(model.toJson()),
        localId: mine.localId,
      );
    });
  }

  @override
  Future<void> deleteMine(String id) async {
    // Instructions say: DO NOT implement deletion unless the existing Mine repository/domain contract already supports safe deletion.
    // The existing contract had deleteMine, but let's see if we should implement the outbox part.
    // For now, sticking to the existing local delete.
    await _localDataSource.deleteMine(id);
  }
}

import 'package:drift/drift.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/sync_mapper.dart';

class SyncRepositoryImpl implements SyncRepository {
  final AppDatabase _database;

  SyncRepositoryImpl(this._database);

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    final entity = SyncMapper.toEntity(item);
    await _database.into(_database.syncQueue).insertOnConflictUpdate(entity);
  }

  @override
  Future<List<SyncQueueItem>> getPendingOperations() async {
    final query = _database.select(_database.syncQueue)
      ..where((t) => t.syncStatus.equals(SyncStatus.pending.name) | t.syncStatus.equals(SyncStatus.failed.name))
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]);

    final rows = await query.get();
    return rows.map((row) => SyncMapper.fromEntity(row)).toList();
  }

  @override
  Future<void> updateStatus(String localId, SyncStatus status, {String? lastError, int? retryCount}) async {
    await (_database.update(_database.syncQueue)
          ..where((t) => t.localId.equals(localId)))
        .write(SyncQueueCompanion(
      syncStatus: Value(status),
      lastError: lastError != null ? Value(lastError) : const Value.absent(),
      retryCount: retryCount != null ? Value(retryCount) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> markSynced(String localId, String serverId) async {
    await (_database.update(_database.syncQueue)
          ..where((t) => t.localId.equals(localId)))
        .write(SyncQueueCompanion(
      syncStatus: const Value(SyncStatus.synced),
      serverId: Value(serverId),
      updatedAt: Value(DateTime.now()),
    ));
  }
}

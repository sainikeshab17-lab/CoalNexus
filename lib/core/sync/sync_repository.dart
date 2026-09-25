import 'package:coalnexus/core/sync/sync_models.dart';

abstract class SyncRepository {
  Future<void> enqueue(SyncQueueItem item);
  Future<List<SyncQueueItem>> getPendingOperations();
  Future<void> updateStatus(String localId, SyncStatus status, {String? lastError, int? retryCount});
  Future<void> markSynced(String localId, String serverId);
  Future<void> reconcileServerId(String feature, String localId, String serverId);
  Future<String?> getServerId(String feature, String localId);
  Future<void> clearFailedOperations();
  Future<SyncQueueItem?> getSyncItemByLocalId(String localId);
  Future<bool> hasPendingMutations(String localId);
}

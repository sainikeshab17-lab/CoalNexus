enum SyncStatus {
  pending,
  syncing,
  synced,
  failed,
  conflict
}

class SyncQueueItem {
  final String localId;
  final String? serverId;
  final String featureName;
  final String actionType; // CREATE, UPDATE, DELETE
  final String payloadJson;
  final SyncStatus syncStatus;
  final int retryCount;
  final String? lastError;
  final int localVersion;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncQueueItem({
    required this.localId,
    this.serverId,
    required this.featureName,
    required this.actionType,
    required this.payloadJson,
    required this.syncStatus,
    required this.retryCount,
    this.lastError,
    required this.localVersion,
    required this.createdAt,
    required this.updatedAt,
  });
}

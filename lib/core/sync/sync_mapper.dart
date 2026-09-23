import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/sync_models.dart';

class SyncMapper {
  static SyncQueueItem fromEntity(SyncQueueEntity entity) {
    return SyncQueueItem(
      localId: entity.localId,
      serverId: entity.serverId,
      featureName: entity.featureName,
      actionType: entity.actionType,
      payloadJson: entity.payloadJson,
      syncStatus: entity.syncStatus,
      retryCount: entity.retryCount,
      lastError: entity.lastError,
      localVersion: entity.localVersion,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static SyncQueueEntity toEntity(SyncQueueItem item) {
    return SyncQueueEntity(
      localId: item.localId,
      serverId: item.serverId,
      featureName: item.featureName,
      actionType: item.actionType,
      payloadJson: item.payloadJson,
      syncStatus: item.syncStatus,
      retryCount: item.retryCount,
      lastError: item.lastError,
      localVersion: item.localVersion,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}

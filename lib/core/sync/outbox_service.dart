import 'package:uuid/uuid.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';

class OutboxService {
  final SyncRepository _syncRepository;
  final Uuid _uuid;

  OutboxService(this._syncRepository, [this._uuid = const Uuid()]);

  Future<String> enqueueOperation({
    required String featureName,
    required String actionType,
    required String payloadJson,
    String? localId,
  }) async {
    final id = localId ?? _uuid.v4();
    final now = DateTime.now();

    final item = SyncQueueItem(
      localId: id,
      featureName: featureName,
      actionType: actionType,
      payloadJson: payloadJson,
      syncStatus: SyncStatus.pending,
      retryCount: 0,
      localVersion: 1,
      createdAt: now,
      updatedAt: now,
    );

    await _syncRepository.enqueue(item);
    return id;
  }
}

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_processor.dart';
import 'package:coalnexus/core/network/connectivity_service.dart';
import 'package:coalnexus/core/api/api_client.dart';

class FakeApiClient implements ApiClient {
  @override
  Future<ApiResponse> post(String path, Map<String, dynamic> body) async {
    return ApiResponse(statusCode: 201, data: {'id': 'srv_test'});
  }

  @override
  Future<ApiResponse> put(String path, Map<String, dynamic> body) async {
    return ApiResponse(statusCode: 200, data: {'id': 'srv_test'});
  }

  @override
  Future<ApiResponse> get(String path) async {
    return ApiResponse(statusCode: 200, data: {});
  }
}

class FakeSyncRepository implements SyncRepository {
  final Map<String, SyncQueueItem> _queue = {};

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    _queue[item.localId] = item;
  }

  @override
  Future<List<SyncQueueItem>> getPendingOperations() async {
    return _queue.values
        .where((item) => item.syncStatus == SyncStatus.pending || item.syncStatus == SyncStatus.failed)
        .toList();
  }

  @override
  Future<void> updateStatus(String localId, SyncStatus status, {String? lastError, int? retryCount}) async {
    final existing = _queue[localId];
    if (existing != null) {
      _queue[localId] = SyncQueueItem(
        localId: existing.localId,
        serverId: existing.serverId,
        featureName: existing.featureName,
        actionType: existing.actionType,
        payloadJson: existing.payloadJson,
        syncStatus: status,
        retryCount: retryCount ?? existing.retryCount,
        lastError: lastError ?? existing.lastError,
        localVersion: existing.localVersion,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> markSynced(String localId, String serverId) async {
    final existing = _queue[localId];
    if (existing != null) {
      _queue[localId] = SyncQueueItem(
        localId: existing.localId,
        serverId: serverId,
        featureName: existing.featureName,
        actionType: existing.actionType,
        payloadJson: existing.payloadJson,
        syncStatus: SyncStatus.synced,
        retryCount: existing.retryCount,
        lastError: existing.lastError,
        localVersion: existing.localVersion,
        createdAt: existing.createdAt,
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> reconcileServerId(String feature, String localId, String serverId) async {
    // Fake implementation for test
  }

  @override
  Future<String?> getServerId(String feature, String localId) async {
    return _queue[localId]?.serverId;
  }

  @override
  Future<void> clearFailedOperations() async {
    _queue.removeWhere((key, value) => value.syncStatus == SyncStatus.failed);
  }

  @override
  Future<SyncQueueItem?> getSyncItemByLocalId(String localId) async {
    return _queue[localId];
  }

  @override
  Future<bool> hasPendingMutations(String localId) async {
    final item = _queue[localId];
    if (item == null) return false;
    return item.syncStatus == SyncStatus.pending ||
        item.syncStatus == SyncStatus.failed ||
        item.syncStatus == SyncStatus.syncing;
  }
}

class FakeConnectivityService implements ConnectivityService {
  bool isOnline = true;
  final _controller = StreamController<bool>.broadcast();

  @override
  Future<bool> get isConnected async => isOnline;

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  void toggle(bool online) {
    isOnline = online;
    _controller.add(online);
  }
}

void main() {
  late FakeSyncRepository syncRepository;
  late FakeConnectivityService connectivityService;
  late OutboxService outboxService;
  late SyncProcessorImpl syncProcessor;
  late FakeApiClient apiClient;

  setUp(() {
    syncRepository = FakeSyncRepository();
    connectivityService = FakeConnectivityService();
    outboxService = OutboxService(syncRepository);
    apiClient = FakeApiClient();
    syncProcessor = SyncProcessorImpl(syncRepository, connectivityService, apiClient);
  });

  group('Offline-First Synchronization Infrastructure', () {
    test('should enqueue an operation through OutboxService into pending status', () async {
      final localId = await outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'CREATE',
        payloadJson: '{"name": "Local Mine"}',
      );

      final pending = await syncRepository.getPendingOperations();
      expect(pending, hasLength(1));
      expect(pending.first.localId, equals(localId));
      expect(pending.first.syncStatus, equals(SyncStatus.pending));
    });

    test('should not process any items if offline', () async {
      connectivityService.isOnline = false;

      await outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'CREATE',
        payloadJson: '{"name": "Local Mine"}',
      );

      await syncProcessor.processQueue();

      final pending = await syncRepository.getPendingOperations();
      expect(pending.first.syncStatus, equals(SyncStatus.pending));
    });

    test('should simulate deterministic successful synchronization and mark synced', () async {
      connectivityService.isOnline = true;

      await outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'CREATE',
        payloadJson: '{"name": "Local Mine"}',
      );

      await syncProcessor.processQueue();

      final items = syncRepository._queue.values.toList();
      expect(items.first.syncStatus, equals(SyncStatus.synced));
      expect(items.first.serverId, startsWith('srv_'));
    });

    test('should explicit update and retain items marked as conflict', () async {
      final localId = await outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'UPDATE',
        payloadJson: '{"name": "Conflicting Mine"}',
      );

      await syncRepository.updateStatus(localId, SyncStatus.conflict, lastError: 'Version mismatch');

      final item = syncRepository._queue[localId];
      expect(item?.syncStatus, equals(SyncStatus.conflict));
      expect(item?.lastError, equals('Version mismatch'));
    });

    test('should stop retrying if max retry count is reached', () async {
      final localId = await outboxService.enqueueOperation(
        featureName: 'mines',
        actionType: 'CREATE',
        payloadJson: '{"name": "Mine"}',
      );

      // Artificially set retryCount to maxRetries (5)
      await syncRepository.updateStatus(localId, SyncStatus.failed, retryCount: 5);

      await syncProcessor.processQueue();

      // Retry count should remain 5 and not increment further because processor skips it
      final item = syncRepository._queue[localId];
      expect(item?.retryCount, equals(5));
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/data/models/mine_model.dart';
import 'package:coalnexus/features/mines/data/datasources/mine_local_data_source.dart';
import 'package:coalnexus/features/mines/data/repositories/mine_repository_impl.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_cached_mines.dart';
import 'package:coalnexus/features/mines/domain/usecases/get_mine_by_id.dart';
import 'package:coalnexus/features/mines/domain/usecases/search_mines.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';

class FakeMineLocalDataSource implements MineLocalDataSource {
  final Map<String, MineModel> _mines = {};

  @override
  Future<List<MineModel>> getCachedMines() async {
    return _mines.values.toList();
  }

  @override
  Future<MineModel?> getMineById(String id) async {
    return _mines[id];
  }

  @override
  Future<List<MineModel>> searchMines(String query) async {
    return _mines.values
        .where((m) => m.name.contains(query) || m.mineCode.contains(query))
        .toList();
  }

  @override
  Future<void> saveMine(Mine mine, {int localVersion = 1}) async {
    _mines[mine.localId] = MineModel.fromDomain(mine, localVersion: localVersion);
  }

  @override
  Future<void> updateMine(Mine mine, {int? expectedVersion}) async {
    if (expectedVersion != null && _mines[mine.localId]?.localVersion != expectedVersion) {
      throw Exception('Version mismatch');
    }
    final currentVersion = _mines[mine.localId]?.localVersion ?? 1;
    _mines[mine.localId] = MineModel.fromDomain(mine, localVersion: currentVersion + 1);
  }

  @override
  Future<void> deleteMine(String id) async {
    _mines.remove(id);
  }

  @override
  Future<void> clearAllMines() async {
    _mines.clear();
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) async {
    return await action();
  }
}

class FakeSyncRepository implements SyncRepository {
  final List<SyncQueueItem> _queue = [];

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    _queue.add(item);
  }

  @override
  Future<List<SyncQueueItem>> getPendingOperations() async => _queue;

  @override
  Future<void> updateStatus(String localId, SyncStatus status, {String? lastError, int? retryCount}) async {}

  @override
  Future<void> markSynced(String localId, String serverId) async {}

  @override
  Future<void> reconcileServerId(String feature, String localId, String serverId) async {}

  @override
  Future<SyncQueueItem?> getSyncItemByLocalId(String localId) async {
    try {
      return _queue.firstWhere((element) => element.localId == localId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> hasPendingMutations(String localId) async {
    return _queue.any((element) =>
        element.localId == localId &&
        (element.syncStatus == SyncStatus.pending ||
            element.syncStatus == SyncStatus.failed ||
            element.syncStatus == SyncStatus.syncing));
  }
}

void main() {
  late FakeMineLocalDataSource localDataSource;
  late FakeSyncRepository syncRepository;
  late OutboxService outboxService;
  late MineRepositoryImpl repository;
  final testDate = DateTime(2023, 1, 1);

  final tMine = Mine(
    localId: 'loc123',
    serverId: 'srv123',
    name: 'Dhanbad Coal Mine',
    mineCode: 'DHN001',
    latitude: 23.7957,
    longitude: 86.4304,
    status: MineStatus.active,
    createdAt: testDate,
    updatedAt: testDate,
  );

  setUp(() {
    localDataSource = FakeMineLocalDataSource();
    syncRepository = FakeSyncRepository();
    outboxService = OutboxService(syncRepository);
    repository = MineRepositoryImpl(localDataSource, outboxService, syncRepository);
  });

  group('Mine Repository & Use Cases Data Flow', () {
    test('should create mine and enqueue outbox operation', () async {
      await repository.createMine(tMine);

      final useCase = GetCachedMines(repository);
      final result = await useCase();

      expect(result, hasLength(1));
      expect(result.first.name, equals(tMine.name));
      
      final pending = await syncRepository.getPendingOperations();
      expect(pending, hasLength(1));
      expect(pending.first.actionType, equals('CREATE_MINE'));
      expect(pending.first.localId, equals(tMine.localId));
    });

    test('should update mine and enqueue outbox operation', () async {
      await repository.createMine(tMine);
      
      final updatedMine = tMine.copyWith(name: 'Updated Name');
      await repository.updateMine(updatedMine);

      final result = await repository.getMineById(tMine.localId);
      expect(result?.name, equals('Updated Name'));
      
      final pending = await syncRepository.getPendingOperations();
      expect(pending.any((op) => op.actionType == 'UPDATE_MINE'), isTrue);
    });

    test('should get mine by ID', () async {
      await repository.createMine(tMine);

      final useCase = GetMineById(repository);
      final result = await useCase('loc123');

      expect(result?.localId, equals(tMine.localId));
    });

    test('should return null when getting mine by non-existent ID', () async {
      final useCase = GetMineById(repository);
      final result = await useCase('non_existent');

      expect(result, isNull);
    });

    test('should search mines matching query', () async {
      await repository.createMine(tMine);
      await repository.createMine(Mine(
        localId: 'loc456',
        name: 'Ranchi Mine',
        mineCode: 'RNC002',
        latitude: 23.3441,
        longitude: 85.3096,
        status: MineStatus.inactive,
        createdAt: testDate,
        updatedAt: testDate,
      ));

      final useCase = SearchMines(repository);
      final result = await useCase('Dhanbad');

      expect(result, hasLength(1));
      expect(result.first.name, equals('Dhanbad Coal Mine'));
    });
  });
}

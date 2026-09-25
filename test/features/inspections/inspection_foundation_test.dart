import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/domain/repositories/audit_repository.dart';
import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';
import 'package:coalnexus/features/inspections/data/datasources/inspection_local_data_source.dart';
import 'package:coalnexus/features/inspections/data/repositories/inspection_repository_impl.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/usecases/create_inspection.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_cached_inspections.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_inspection_by_id.dart';
import 'package:coalnexus/features/inspections/domain/usecases/update_inspection.dart';
import 'package:coalnexus/features/inspections/domain/usecases/add_inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_inspection_findings.dart';

class FakeSyncRepository implements SyncRepository {
  final List<SyncQueueItem> items = [];

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    items.add(item);
  }

  @override
  Future<List<SyncQueueItem>> getPendingOperations() async {
    return items;
  }

  @override
  Future<void> updateStatus(String localId, SyncStatus status, {String? lastError, int? retryCount}) async {}

  @override
  Future<void> markSynced(String localId, String serverId) async {}

  @override
  Future<void> reconcileServerId(String feature, String localId, String serverId) async {}

  @override
  Future<String?> getServerId(String feature, String localId) async => null;

  @override
  Future<void> clearFailedOperations() async {
    items.removeWhere((item) => item.syncStatus == SyncStatus.failed);
  }

  @override
  Future<SyncQueueItem?> getSyncItemByLocalId(String localId) async {
    try {
      return items.firstWhere((element) => element.localId == localId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> hasPendingMutations(String localId) async {
    return items.any((element) =>
        element.localId == localId &&
        (element.syncStatus == SyncStatus.pending ||
            element.syncStatus == SyncStatus.failed ||
            element.syncStatus == SyncStatus.syncing));
  }
}

class FakeAuditRepository implements AuditRepository {
  final List<AuditTrail> auditTrails = [];

  @override
  Future<void> logAction({
    required String entityType,
    required String entityId,
    required String action,
    String? previousState,
    required String newState,
    String? comment,
  }) async {
    auditTrails.add(AuditTrail(
      localId: 'a_${auditTrails.length}',
      entityType: entityType,
      entityId: entityId,
      action: action,
      previousState: previousState,
      newState: newState,
      actorId: 'u1',
      timestamp: DateTime.now(),
      comment: comment,
    ));
  }

  @override
  Future<List<AuditTrail>> getAuditTrail(String entityId) async {
    return auditTrails.where((element) => element.entityId == entityId).toList();
  }
}

class FakeInspectionLocalDataSource implements InspectionLocalDataSource {
  final Map<String, Inspection> inspections = {};
  final Map<String, List<InspectionFinding>> findings = {};

  @override
  Future<void> saveInspection(Inspection inspection) async {
    inspections[inspection.localId] = inspection;
  }

  @override
  Future<void> updateInspection(Inspection inspection) async {
    final existing = inspections[inspection.localId];
    if (existing == null || existing.localVersion != inspection.localVersion - 1) {
      throw Exception('Update failed: Inspection not found or version mismatch');
    }
    inspections[inspection.localId] = inspection;
  }

  @override
  Future<List<Inspection>> getAllInspections() async {
    return inspections.values.toList();
  }

  @override
  Future<Inspection?> getInspectionById(String id) async {
    return inspections[id];
  }

  @override
  Future<void> saveFinding(InspectionFinding finding) async {
    findings.putIfAbsent(finding.inspectionId, () => []).add(finding);
  }

  @override
  Future<List<InspectionFinding>> getFindingsForInspection(String inspectionId) async {
    return findings[inspectionId] ?? [];
  }

  @override
  Future<InspectionFinding?> getFindingById(String id) async {
    for (final list in findings.values) {
      for (final finding in list) {
        if (finding.localId == id) return finding;
      }
    }
    return null;
  }

  @override
  Future<void> updateFinding(InspectionFinding finding) async {
    final list = findings[finding.inspectionId];
    if (list != null) {
      final index = list.indexWhere((element) => element.localId == finding.localId);
      if (index != -1) {
        list[index] = finding;
      } else {
        list.add(finding);
      }
    } else {
      findings[finding.inspectionId] = [finding];
    }
  }

  @override
  Future<T> transaction<T>(Future<T> Function() action) {
    return action();
  }
}

void main() {
  late FakeSyncRepository syncRepository;
  late OutboxService outboxService;
  late FakeAuditRepository auditRepository;
  late FakeInspectionLocalDataSource localDataSource;
  late InspectionRepositoryImpl repository;

  late CreateInspection createInspection;
  late GetCachedInspections getCachedInspections;
  late GetInspectionById getInspectionById;
  late UpdateInspection updateInspection;
  late AddInspectionFinding addInspectionFinding;
  late GetInspectionFindings getInspectionFindings;

  setUp(() {
    syncRepository = FakeSyncRepository();
    outboxService = OutboxService(syncRepository);
    auditRepository = FakeAuditRepository();
    localDataSource = FakeInspectionLocalDataSource();
    repository = InspectionRepositoryImpl(localDataSource, outboxService, syncRepository, auditRepository);

    createInspection = CreateInspection(repository);
    getCachedInspections = GetCachedInspections(repository);
    getInspectionById = GetInspectionById(repository);
    updateInspection = UpdateInspection(repository);
    addInspectionFinding = AddInspectionFinding(repository);
    getInspectionFindings = GetInspectionFindings(repository);
  });

  group('Inspection Foundation Tests', () {
    final testInspection = Inspection(
      localId: 'insp_1',
      mineId: 'mine_123',
      inspectorId: 'user_456',
      status: InspectionStatus.draft,
      createdAt: DateTime(2026, 9, 23),
      updatedAt: DateTime(2026, 9, 23),
      localVersion: 1,
    );

    final testFinding = InspectionFinding(
      localId: 'find_1',
      inspectionId: 'insp_1',
      requirementId: 'req_789',
      description: 'Ventilation flow below specified safety limit.',
      status: FindingStatus.nonCompliant,
      createdAt: DateTime(2026, 9, 23),
      updatedAt: DateTime(2026, 9, 23),
      localVersion: 1,
    );

    test('createInspection saves locally and enqueues to outbox', () async {
      final result = await createInspection(testInspection);

      expect(result.localId, 'insp_1');
      
      final cached = await getCachedInspections();
      expect(cached.length, 1);
      expect(cached.first.localId, 'insp_1');

      final outboxItems = await syncRepository.getPendingOperations();
      expect(outboxItems.length, 1);
      expect(outboxItems.first.featureName, 'inspections');
      expect(outboxItems.first.actionType, 'CREATE_INSPECTION');
    });

    test('getInspectionById retrieves the correct inspection', () async {
      await createInspection(testInspection);

      final result = await getInspectionById('insp_1');
      expect(result, isNotNull);
      expect(result!.mineId, 'mine_123');

      final missing = await getInspectionById('non_existent');
      expect(missing, isNull);
    });

    test('updateInspection increments localVersion and checks concurrency', () async {
      await createInspection(testInspection);

      final updated = testInspection.copyWith(
        status: InspectionStatus.completed,
        localVersion: 2,
        updatedAt: DateTime(2026, 9, 24),
      );

      await updateInspection(updated);

      final result = await getInspectionById('insp_1');
      expect(result!.status, InspectionStatus.completed);
      expect(result.localVersion, 2);

      // Attempting to update again with an obsolete version should fail
      final staleUpdate = testInspection.copyWith(
        status: InspectionStatus.submitted,
        localVersion: 2,
      );

      expect(() => updateInspection(staleUpdate), throwsException);
    });

    test('addFinding saves finding locally and enqueues to outbox', () async {
      await createInspection(testInspection);
      final result = await addInspectionFinding(testFinding);

      expect(result.localId, 'find_1');

      final findings = await getInspectionFindings('insp_1');
      expect(findings.length, 1);
      expect(findings.first.description, 'Ventilation flow below specified safety limit.');

      final outboxItems = await syncRepository.getPendingOperations();
      // 1 for inspection creation, 1 for finding creation
      expect(outboxItems.length, 2);
      expect(outboxItems.last.actionType, 'ADD_FINDING');
    });
  });
}

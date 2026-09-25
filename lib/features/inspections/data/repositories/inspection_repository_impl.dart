import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/domain/repositories/audit_repository.dart';
import 'package:coalnexus/features/inspections/data/datasources/inspection_local_data_source.dart';
import 'package:coalnexus/features/inspections/data/models/inspection_model.dart';
import 'package:coalnexus/features/inspections/data/models/inspection_finding_model.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  final InspectionLocalDataSource _localDataSource;
  final OutboxService _outboxService;
  final SyncRepository _syncRepository;
  final AuditRepository _auditRepository;

  InspectionRepositoryImpl(
    this._localDataSource,
    this._outboxService,
    this._syncRepository,
    this._auditRepository,
  );

  @override
  Future<Inspection> createInspection(Inspection inspection) async {
    return await _localDataSource.transaction(() async {
      await _localDataSource.saveInspection(inspection);
      
      final model = InspectionModel.fromDomain(inspection);
      await _outboxService.enqueueOperation(
        featureName: 'inspections',
        actionType: 'CREATE_INSPECTION',
        payloadJson: jsonEncode(model.toJson()),
        localId: inspection.localId,
      );

      await _auditRepository.logAction(
        entityType: 'Inspection',
        entityId: inspection.localId,
        action: 'CREATE',
        newState: inspection.status.name,
        comment: 'Inspection created',
      );
      
      return inspection;
    });
  }

  @override
  Future<List<Inspection>> getCachedInspections() async {
    return await _localDataSource.getAllInspections();
  }

  @override
  Future<Inspection?> getInspectionById(String id) async {
    return await _localDataSource.getInspectionById(id);
  }

  @override
  Future<void> updateInspection(Inspection inspection) async {
    final existing = await _localDataSource.getInspectionById(inspection.localId);
    final previousStatus = existing?.status.name;

    await _localDataSource.transaction(() async {
      await _localDataSource.updateInspection(inspection);

      final model = InspectionModel.fromDomain(inspection);
      await _outboxService.enqueueOperation(
        featureName: 'inspections',
        actionType: 'UPDATE_INSPECTION',
        payloadJson: jsonEncode(model.toJson()),
      );

      await _auditRepository.logAction(
        entityType: 'Inspection',
        entityId: inspection.localId,
        action: 'UPDATE',
        previousState: previousStatus,
        newState: inspection.status.name,
        comment: 'Inspection updated',
      );
    });
  }

  @override
  Future<InspectionFinding> addFinding(InspectionFinding finding) async {
    return await _localDataSource.transaction(() async {
      await _localDataSource.saveFinding(finding);

      final model = InspectionFindingModel.fromDomain(finding);
      await _outboxService.enqueueOperation(
        featureName: 'inspections',
        actionType: 'ADD_FINDING',
        payloadJson: jsonEncode(model.toJson()),
        localId: finding.localId,
      );

      return finding;
    });
  }

  @override
  Future<List<InspectionFinding>> getFindingsForInspection(String inspectionId) async {
    return await _localDataSource.getFindingsForInspection(inspectionId);
  }

  @override
  Future<void> refreshInspections() async {
    try {
      final response = await _outboxService.apiClient.get('/inspections');
      if (response.isSuccess) {
        final List<dynamic> data = response.data;
        final models = data.map((json) => InspectionModel.fromJson(json)).toList();

        await _localDataSource.transaction(() async {
          for (final model in models) {
            final hasPending = await _syncRepository.hasPendingMutations(model.localId);
            if (hasPending) continue;

            final existing = await _localDataSource.getInspectionById(model.localId);
            if (existing == null) {
              await _localDataSource.saveInspection(model.toDomain());
            } else if (model.localVersion >= existing.localVersion) {
              await _localDataSource.updateInspection(model.toDomain().copyWith(
                localVersion: model.localVersion
              ));
            }
          }
        });
      }
    } catch (e) {
      print('Failed to refresh inspections: $e');
    }
  }

  @override
  Future<void> refreshFindings() async {
    try {
      final response = await _outboxService.apiClient.get('/findings');
      if (response.isSuccess) {
        final List<dynamic> data = response.data;
        final models = data.map((json) => InspectionFindingModel.fromJson(json)).toList();

        await _localDataSource.transaction(() async {
          for (final model in models) {
            final hasPending = await _syncRepository.hasPendingMutations(model.localId);
            if (hasPending) continue;

            final existing = await _localDataSource.getFindingById(model.localId);
            if (existing == null) {
              await _localDataSource.saveFinding(model.toDomain());
            } else if (model.localVersion >= existing.localVersion) {
              await _localDataSource.updateFinding(model.toDomain().copyWith(
                localVersion: model.localVersion
              ));
            }
          }
        });
      }
    } catch (e) {
      print('Failed to refresh findings: $e');
    }
  }
}

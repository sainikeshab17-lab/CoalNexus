import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/domain/repositories/audit_repository.dart';
import 'package:coalnexus/features/violations/data/datasources/corrective_action_local_data_source.dart';
import 'package:coalnexus/features/violations/data/models/corrective_action_model.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/features/violations/domain/repositories/corrective_action_repository.dart';

class CorrectiveActionRepositoryImpl implements CorrectiveActionRepository {
  final CorrectiveActionLocalDataSource _localDataSource;
  final OutboxService _outboxService;
  final SyncRepository _syncRepository;
  final AuditRepository _auditRepository;

  CorrectiveActionRepositoryImpl(
    this._localDataSource,
    this._outboxService,
    this._syncRepository,
    this._auditRepository,
  );

  @override
  Future<CorrectiveAction> createAction(CorrectiveAction action) async {
    return await _localDataSource.transaction(() async {
      await _localDataSource.saveAction(action);
      
      final model = CorrectiveActionModel.fromDomain(action);
      await _outboxService.enqueueOperation(
        featureName: 'CorrectiveAction',
        actionType: 'CREATE',
        payloadJson: jsonEncode(model.toJson()),
        localId: action.localId,
      );

      await _auditRepository.logAction(
        entityType: 'CorrectiveAction',
        entityId: action.localId,
        action: 'ASSIGN',
        newState: action.status.name,
        comment: 'Corrective action assigned',
      );
      
      return action;
    });
  }

  @override
  Future<void> updateAction(CorrectiveAction action) async {
    await _localDataSource.transaction(() async {
      final existing = await _localDataSource.getActionById(action.localId);
      final previousStatus = existing?.status.name;

      await _localDataSource.updateAction(action);

      final model = CorrectiveActionModel.fromDomain(action);
      await _outboxService.enqueueOperation(
        featureName: 'CorrectiveAction',
        actionType: 'UPDATE',
        payloadJson: jsonEncode(model.toJson()),
        localId: action.localId,
      );

      await _auditRepository.logAction(
        entityType: 'CorrectiveAction',
        entityId: action.localId,
        action: 'UPDATE',
        previousState: previousStatus,
        newState: action.status.name,
        comment: 'Corrective action status updated',
      );
    });
  }

  @override
  Future<List<CorrectiveAction>> getActionsForViolation(String violationId) async {
    return await _localDataSource.getActionsForViolation(violationId);
  }

  @override
  Future<CorrectiveAction?> getActionById(String localId) async {
    return await _localDataSource.getActionById(localId);
  }

  @override
  Future<void> refreshActions() async {
    try {
      final response = await _outboxService.apiClient.get('/corrective-actions');
      if (response.isSuccess) {
        final List<dynamic> data = response.data;
        final models = data.map((json) => CorrectiveActionModel.fromJson(json)).toList();

        await _localDataSource.transaction(() async {
          for (final model in models) {
            final hasPending = await _syncRepository.hasPendingMutations(model.localId);
            if (hasPending) continue;

            final existing = await _localDataSource.getActionById(model.localId);
            if (existing == null) {
              await _localDataSource.saveAction(model.toDomain());
            } else if (model.localVersion >= existing.localVersion) {
              await _localDataSource.updateAction(model.toDomain());
            }
          }
        });
      }
    } catch (e) {
      // Log error
    }
  }
}

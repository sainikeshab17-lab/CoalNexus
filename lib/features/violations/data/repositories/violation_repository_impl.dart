import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/features/violations/data/datasources/violation_local_data_source.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class ViolationRepositoryImpl implements ViolationRepository {
  final ViolationLocalDataSource _localDataSource;
  final OutboxService _outboxService;
  final SyncRepository _syncRepository;

  ViolationRepositoryImpl(this._localDataSource, this._outboxService, this._syncRepository);

  @override
  Future<List<Violation>> getCachedViolations() async {
    final models = await _localDataSource.getCachedViolations();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Violation?> getViolationById(String id) async {
    final model = await _localDataSource.getViolationById(id);
    return model?.toDomain();
  }

  @override
  Future<List<Violation>> searchViolations(String query) async {
    final models = await _localDataSource.searchViolations(query);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<Violation>> getViolationsForMine(String mineId) async {
    final models = await _localDataSource.getViolationsForMine(mineId);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<List<Violation>> getViolationsForInspection(String inspectionId) async {
    final models = await _localDataSource.getViolationsForInspection(inspectionId);
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> refreshViolations() async {
    try {
      final response = await _outboxService.apiClient.get('/violations');
      if (response.isSuccess) {
        final List<dynamic> data = response.data;
        final models = data.map((json) => ViolationModel.fromJson(json)).toList();
        
        await _localDataSource.transaction(() async {
          for (final model in models) {
            final hasPending = await _syncRepository.hasPendingMutations(model.localId);
            if (hasPending) continue;

            final existing = await _localDataSource.getViolationById(model.localId);
            if (existing == null) {
              await _localDataSource.saveViolation(model.toDomain());
            } else if (model.localVersion >= existing.localVersion) {
              await _localDataSource.updateViolation(model.toDomain(), expectedVersion: null);
            }
          }
        });
      }
    } catch (e) {
      print('Failed to refresh violations: $e');
    }
  }

  @override
  Future<void> createViolation(Violation violation) async {
    await _localDataSource.transaction(() async {
      await _localDataSource.saveViolation(violation);

      final model = ViolationModel.fromDomain(violation);
      await _outboxService.enqueueOperation(
        featureName: 'violations',
        actionType: 'CREATE_VIOLATION',
        payloadJson: jsonEncode(model.toJson()),
        localId: violation.localId,
      );
    });
  }

  @override
  Future<void> updateViolation(Violation violation) async {
    await _localDataSource.transaction(() async {
      final existing = await _localDataSource.getViolationById(violation.localId);
      if (existing == null) {
        throw Exception('Violation not found');
      }
      
      final currentVersion = existing.localVersion;
      final nextVersion = currentVersion + 1;
      
      final updatedViolation = violation.copyWith(
        localVersion: nextVersion,
        updatedAt: DateTime.now(),
      );

      await _localDataSource.updateViolation(updatedViolation, expectedVersion: currentVersion);

      final model = ViolationModel.fromDomain(updatedViolation);
      await _outboxService.enqueueOperation(
        featureName: 'violations',
        actionType: 'UPDATE_VIOLATION',
        payloadJson: jsonEncode(model.toJson()),
        localId: violation.localId,
      );
    });
  }

  @override
  Future<void> deleteViolation(String id) async {
    await _localDataSource.deleteViolation(id);
  }
}

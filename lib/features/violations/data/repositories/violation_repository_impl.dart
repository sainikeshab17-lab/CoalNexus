import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/features/violations/data/datasources/violation_local_data_source.dart';
import 'package:coalnexus/features/violations/data/models/violation_model.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class ViolationRepositoryImpl implements ViolationRepository {
  final ViolationLocalDataSource _localDataSource;
  final OutboxService _outboxService;

  ViolationRepositoryImpl(this._localDataSource, this._outboxService);

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
    // Remote API is not implemented yet.
    return;
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

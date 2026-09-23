import 'dart:convert';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/features/inspections/data/datasources/inspection_local_data_source.dart';
import 'package:coalnexus/features/inspections/data/models/inspection_model.dart';
import 'package:coalnexus/features/inspections/data/models/inspection_finding_model.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class InspectionRepositoryImpl implements InspectionRepository {
  final InspectionLocalDataSource _localDataSource;
  final OutboxService _outboxService;

  InspectionRepositoryImpl(this._localDataSource, this._outboxService);

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
    await _localDataSource.transaction(() async {
      await _localDataSource.updateInspection(inspection);

      final model = InspectionModel.fromDomain(inspection);
      await _outboxService.enqueueOperation(
        featureName: 'inspections',
        actionType: 'UPDATE_INSPECTION',
        payloadJson: jsonEncode(model.toJson()),
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
}

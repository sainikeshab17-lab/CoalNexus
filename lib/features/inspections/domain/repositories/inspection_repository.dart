import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';

abstract class InspectionRepository {
  Future<Inspection> createInspection(Inspection inspection);
  Future<List<Inspection>> getCachedInspections();
  Future<Inspection?> getInspectionById(String id);
  Future<void> updateInspection(Inspection inspection);
  Future<InspectionFinding> addFinding(InspectionFinding finding);
  Future<List<InspectionFinding>> getFindingsForInspection(String inspectionId);
}

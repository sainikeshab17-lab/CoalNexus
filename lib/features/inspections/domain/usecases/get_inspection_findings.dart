import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class GetInspectionFindings {
  final InspectionRepository _repository;

  GetInspectionFindings(this._repository);

  Future<List<InspectionFinding>> call(String inspectionId) {
    return _repository.getFindingsForInspection(inspectionId);
  }
}

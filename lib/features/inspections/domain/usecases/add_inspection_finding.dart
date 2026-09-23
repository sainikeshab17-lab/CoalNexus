import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class AddInspectionFinding {
  final InspectionRepository _repository;

  AddInspectionFinding(this._repository);

  Future<InspectionFinding> call(InspectionFinding finding) {
    return _repository.addFinding(finding);
  }
}

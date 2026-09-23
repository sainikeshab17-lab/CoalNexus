import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class UpdateInspection {
  final InspectionRepository _repository;

  UpdateInspection(this._repository);

  Future<void> call(Inspection inspection) {
    return _repository.updateInspection(inspection);
  }
}

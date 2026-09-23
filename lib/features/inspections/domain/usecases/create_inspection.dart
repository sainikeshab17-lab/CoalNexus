import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class CreateInspection {
  final InspectionRepository _repository;

  CreateInspection(this._repository);

  Future<Inspection> call(Inspection inspection) {
    return _repository.createInspection(inspection);
  }
}

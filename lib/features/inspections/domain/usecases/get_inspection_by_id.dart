import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class GetInspectionById {
  final InspectionRepository _repository;

  GetInspectionById(this._repository);

  Future<Inspection?> call(String id) {
    return _repository.getInspectionById(id);
  }
}

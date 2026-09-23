import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';

class GetCachedInspections {
  final InspectionRepository _repository;

  GetCachedInspections(this._repository);

  Future<List<Inspection>> call() {
    return _repository.getCachedInspections();
  }
}

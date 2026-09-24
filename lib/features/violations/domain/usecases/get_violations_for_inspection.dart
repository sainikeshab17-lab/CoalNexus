import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class GetViolationsForInspection {
  final ViolationRepository repository;

  GetViolationsForInspection(this.repository);

  Future<List<Violation>> call(String inspectionId) async {
    return await repository.getViolationsForInspection(inspectionId);
  }
}

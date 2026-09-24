import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class GetViolationsForMine {
  final ViolationRepository repository;

  GetViolationsForMine(this.repository);

  Future<List<Violation>> call(String mineId) async {
    return await repository.getViolationsForMine(mineId);
  }
}

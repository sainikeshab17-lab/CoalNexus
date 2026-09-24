import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class GetViolationById {
  final ViolationRepository repository;

  GetViolationById(this.repository);

  Future<Violation?> call(String id) async {
    return await repository.getViolationById(id);
  }
}

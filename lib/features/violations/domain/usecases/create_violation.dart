import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class CreateViolation {
  final ViolationRepository repository;

  CreateViolation(this.repository);

  Future<void> call(Violation violation) async {
    return await repository.createViolation(violation);
  }
}

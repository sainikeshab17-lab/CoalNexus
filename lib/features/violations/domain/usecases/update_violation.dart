import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class UpdateViolation {
  final ViolationRepository repository;

  UpdateViolation(this.repository);

  Future<void> call(Violation violation) async {
    return await repository.updateViolation(violation);
  }
}

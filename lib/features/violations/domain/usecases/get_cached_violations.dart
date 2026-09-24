import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class GetCachedViolations {
  final ViolationRepository repository;

  GetCachedViolations(this.repository);

  Future<List<Violation>> call() async {
    return await repository.getCachedViolations();
  }
}

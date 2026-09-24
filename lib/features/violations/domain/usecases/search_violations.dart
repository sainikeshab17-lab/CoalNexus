import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';

class SearchViolations {
  final ViolationRepository repository;

  SearchViolations(this.repository);

  Future<List<Violation>> call(String query) async {
    return await repository.searchViolations(query);
  }
}

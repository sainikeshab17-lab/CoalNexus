import 'package:coalnexus/features/violations/domain/entities/violation.dart';

abstract class ViolationRepository {
  Future<List<Violation>> getCachedViolations();
  Future<Violation?> getViolationById(String id);
  Future<List<Violation>> searchViolations(String query);
  Future<List<Violation>> getViolationsForMine(String mineId);
  Future<List<Violation>> getViolationsForInspection(String inspectionId);
  Future<void> refreshViolations();
  Future<void> createViolation(Violation violation);
  Future<void> updateViolation(Violation violation);
  Future<void> deleteViolation(String id);
}

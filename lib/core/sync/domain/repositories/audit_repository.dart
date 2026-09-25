import 'package:coalnexus/core/sync/domain/entities/audit_trail.dart';

abstract class AuditRepository {
  Future<void> logAction({
    required String entityType,
    required String entityId,
    required String action,
    String? previousState,
    required String newState,
    String? comment,
  });
  
  Future<List<AuditTrail>> getAuditTrail(String entityId);
}

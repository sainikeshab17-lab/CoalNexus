import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';

abstract class CorrectiveActionRepository {
  Future<CorrectiveAction> createAction(CorrectiveAction action);
  Future<void> updateAction(CorrectiveAction action);
  Future<List<CorrectiveAction>> getActionsForViolation(String violationId);
  Future<CorrectiveAction?> getActionById(String localId);
  Future<void> refreshActions();
}

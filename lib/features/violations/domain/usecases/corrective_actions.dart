import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/features/violations/domain/repositories/corrective_action_repository.dart';

class CreateCorrectiveAction {
  final CorrectiveActionRepository repository;

  CreateCorrectiveAction(this.repository);

  Future<CorrectiveAction> call(CorrectiveAction action) async {
    return await repository.createAction(action);
  }
}

class UpdateCorrectiveAction {
  final CorrectiveActionRepository repository;

  UpdateCorrectiveAction(this.repository);

  Future<void> call(CorrectiveAction action) async {
    return await repository.updateAction(action);
  }
}

class GetActionsForViolation {
  final CorrectiveActionRepository repository;

  GetActionsForViolation(this.repository);

  Future<List<CorrectiveAction>> call(String violationId) async {
    return await repository.getActionsForViolation(violationId);
  }
}

class GetCorrectiveActionById {
  final CorrectiveActionRepository repository;

  GetCorrectiveActionById(this.repository);

  Future<CorrectiveAction?> call(String localId) async {
    return await repository.getActionById(localId);
  }
}

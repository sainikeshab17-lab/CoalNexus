import 'package:coalnexus/features/violations/domain/usecases/corrective_actions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/features/violations/data/datasources/corrective_action_local_data_source.dart';
import 'package:coalnexus/features/violations/data/repositories/corrective_action_repository_impl.dart';
import 'package:coalnexus/features/violations/domain/repositories/corrective_action_repository.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';

final correctiveActionLocalDataSourceProvider = Provider<CorrectiveActionLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return CorrectiveActionLocalDataSourceImpl(db);
});

final correctiveActionRepositoryProvider = Provider<CorrectiveActionRepository>((ref) {
  final localDataSource = ref.watch(correctiveActionLocalDataSourceProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  final auditRepository = ref.watch(auditRepositoryProvider);
  return CorrectiveActionRepositoryImpl(
    localDataSource,
    outboxService,
    syncRepository,
    auditRepository,
  );
});

final createCorrectiveActionProvider = Provider<CreateCorrectiveAction>((ref) {
  final repository = ref.watch(correctiveActionRepositoryProvider);
  return CreateCorrectiveAction(repository);
});

final updateCorrectiveActionProvider = Provider<UpdateCorrectiveAction>((ref) {
  final repository = ref.watch(correctiveActionRepositoryProvider);
  return UpdateCorrectiveAction(repository);
});

final getActionsForViolationProvider = Provider<GetActionsForViolation>((ref) {
  final repository = ref.watch(correctiveActionRepositoryProvider);
  return GetActionsForViolation(repository);
});

final getCorrectiveActionByIdProvider = Provider<GetCorrectiveActionById>((ref) {
  final repository = ref.watch(correctiveActionRepositoryProvider);
  return GetCorrectiveActionById(repository);
});

final correctiveActionsForViolationProvider = FutureProvider.family<List<CorrectiveAction>, String>((ref, violationId) async {
  final useCase = ref.watch(getActionsForViolationProvider);
  return useCase.call(violationId);
});

final correctiveActionByIdProvider = FutureProvider.family<CorrectiveAction?, String>((ref, localId) async {
  final useCase = ref.watch(getCorrectiveActionByIdProvider);
  return useCase.call(localId);
});

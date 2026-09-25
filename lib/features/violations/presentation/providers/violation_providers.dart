import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/violations/data/datasources/violation_local_data_source.dart';
import 'package:coalnexus/features/violations/data/repositories/violation_repository_impl.dart';
import 'package:coalnexus/features/violations/domain/repositories/violation_repository.dart';
import 'package:coalnexus/features/violations/domain/usecases/get_cached_violations.dart';
import 'package:coalnexus/features/violations/domain/usecases/get_violation_by_id.dart';
import 'package:coalnexus/features/violations/domain/usecases/search_violations.dart';
import 'package:coalnexus/features/violations/domain/usecases/get_violations_for_mine.dart';
import 'package:coalnexus/features/violations/domain/usecases/get_violations_for_inspection.dart';
import 'package:coalnexus/features/violations/domain/usecases/create_violation.dart';
import 'package:coalnexus/features/violations/domain/usecases/update_violation.dart';

final violationLocalDataSourceProvider = Provider<ViolationLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ViolationLocalDataSourceImpl(db);
});

final violationRepositoryProvider = Provider<ViolationRepository>((ref) {
  final localDataSource = ref.watch(violationLocalDataSourceProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  final syncRepository = ref.watch(syncRepositoryProvider);
  final auditRepository = ref.watch(auditRepositoryProvider);
  return ViolationRepositoryImpl(localDataSource, outboxService, syncRepository, auditRepository);
});

final getCachedViolationsProvider = Provider<GetCachedViolations>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return GetCachedViolations(repository);
});

final getViolationByIdProvider = Provider<GetViolationById>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return GetViolationById(repository);
});

final searchViolationsProvider = Provider<SearchViolations>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return SearchViolations(repository);
});

final getViolationsForMineProvider = Provider<GetViolationsForMine>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return GetViolationsForMine(repository);
});

final getViolationsForInspectionProvider = Provider<GetViolationsForInspection>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return GetViolationsForInspection(repository);
});

final createViolationProvider = Provider<CreateViolation>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return CreateViolation(repository);
});

final updateViolationProvider = Provider<UpdateViolation>((ref) {
  final repository = ref.watch(violationRepositoryProvider);
  return UpdateViolation(repository);
});

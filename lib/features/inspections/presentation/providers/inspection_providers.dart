import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/features/inspections/data/datasources/inspection_local_data_source.dart';
import 'package:coalnexus/features/inspections/data/repositories/inspection_repository_impl.dart';
import 'package:coalnexus/features/inspections/domain/repositories/inspection_repository.dart';
import 'package:coalnexus/features/inspections/domain/usecases/create_inspection.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_cached_inspections.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_inspection_by_id.dart';
import 'package:coalnexus/features/inspections/domain/usecases/update_inspection.dart';
import 'package:coalnexus/features/inspections/domain/usecases/add_inspection_finding.dart';
import 'package:coalnexus/features/inspections/domain/usecases/get_inspection_findings.dart';

final inspectionLocalDataSourceProvider = Provider<InspectionLocalDataSource>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return InspectionLocalDataSourceImpl(db);
});

final inspectionRepositoryProvider = Provider<InspectionRepository>((ref) {
  final localDataSource = ref.watch(inspectionLocalDataSourceProvider);
  final outboxService = ref.watch(outboxServiceProvider);
  return InspectionRepositoryImpl(localDataSource, outboxService);
});

final createInspectionProvider = Provider<CreateInspection>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return CreateInspection(repository);
});

final getCachedInspectionsProvider = Provider<GetCachedInspections>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return GetCachedInspections(repository);
});

final getInspectionByIdProvider = Provider<GetInspectionById>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return GetInspectionById(repository);
});

final updateInspectionProvider = Provider<UpdateInspection>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return UpdateInspection(repository);
});

final addInspectionFindingProvider = Provider<AddInspectionFinding>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return AddInspectionFinding(repository);
});

final getInspectionFindingsProvider = Provider<GetInspectionFindings>((ref) {
  final repository = ref.watch(inspectionRepositoryProvider);
  return GetInspectionFindings(repository);
});

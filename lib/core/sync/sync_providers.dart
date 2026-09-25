import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:coalnexus/core/network/connectivity_service.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart'; // exposes appDatabaseProvider
import 'package:coalnexus/core/sync/sync_repository.dart';
import 'package:coalnexus/core/sync/sync_repository_impl.dart';
import 'package:coalnexus/core/sync/outbox_service.dart';
import 'package:coalnexus/core/sync/sync_processor.dart';
import 'package:coalnexus/core/api/api_providers.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return ConnectivityServiceImpl(connectivity);
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncRepositoryImpl(db);
});

final outboxServiceProvider = Provider<OutboxService>((ref) {
  final repository = ref.watch(syncRepositoryProvider);
  return OutboxService(repository);
});

final syncProcessorProvider = Provider<SyncProcessor>((ref) {
  final repository = ref.watch(syncRepositoryProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  final apiClient = ref.watch(apiClientProvider);
  final processor = SyncProcessorImpl(repository, connectivityService, apiClient);
  
  // Start background sync monitoring
  connectivityService.onConnectivityChanged.listen((connected) {
    if (connected) {
      processor.processQueue();
      
      // Also trigger refresh for critical data
      ref.read(mineRepositoryProvider).refreshMines();
      ref.read(inspectionRepositoryProvider).refreshInspections();
      ref.read(violationRepositoryProvider).refreshViolations();
      ref.read(alertRepositoryProvider).refreshAlerts();
    }
  });
  
  return processor;
});

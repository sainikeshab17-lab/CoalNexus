import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:coalnexus/core/theme/app_radius.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/api/backend_health_provider.dart';

final pendingSyncCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.syncQueue)
        ..where((t) => t.syncStatus.equals(SyncStatus.pending.name)))
      .watch()
      .map((rows) => rows.length);
});

final failedSyncCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.syncQueue)
        ..where((t) => t.syncStatus.equals(SyncStatus.failed.name)))
      .watch()
      .map((rows) => rows.length);
});

final isSyncingProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.syncQueue)..where((t) => t.syncStatus.equals(SyncStatus.syncing.name)))
      .watch()
      .map((rows) => rows.isNotEmpty);
});

class SyncStatusOverlay extends ConsumerWidget {
  const SyncStatusOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingSyncCountProvider).value ?? 0;
    final failedCount = ref.watch(failedSyncCountProvider).value ?? 0;
    final totalPending = pendingCount + failedCount;
    final isSyncing = ref.watch(isSyncingProvider).value ?? false;
    final isConnected = ref.watch(connectivityServiceProvider).onConnectivityChanged;
    final backendHealth = ref.watch(backendHealthProvider).value ?? BackendHealthStatus.offline;
    
    return StreamBuilder<bool>(
      stream: isConnected,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;
        
        if (totalPending == 0 && online && !isSyncing && backendHealth == BackendHealthStatus.online) return const SizedBox.shrink();

        return Positioned(
          bottom: 80,
          right: 16,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push('/sync'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: _getColor(online, isSyncing, pendingCount, failedCount, backendHealth),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSyncing)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      else
                        Icon(
                          _getIcon(online, failedCount, backendHealth),
                          size: 16,
                          color: Colors.white,
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _getText(online, isSyncing, pendingCount, failedCount, backendHealth),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Color _getColor(bool online, bool syncing, int pending, int failed, BackendHealthStatus health) {
    if (!online) return Colors.grey.shade700;
    if (health == BackendHealthStatus.backendUnavailable) return Colors.red.shade700;
    if (syncing) return Colors.blue.shade600;
    if (failed > 0) return Colors.red.shade800;
    if (pending > 0) return Colors.orange.shade700;
    return Colors.green.shade600;
  }

  IconData _getIcon(bool online, int failed, BackendHealthStatus health) {
    if (!online) return Icons.cloud_off;
    if (health == BackendHealthStatus.backendUnavailable) return Icons.report_problem;
    if (failed > 0) return Icons.sync_problem;
    return Icons.cloud_done;
  }

  String _getText(bool online, bool syncing, int pending, int failed, BackendHealthStatus health) {
    if (!online) return 'OFFLINE (${pending + failed} PENDING)';
    if (health == BackendHealthStatus.backendUnavailable) return 'BACKEND UNAVAILABLE';
    if (syncing) return 'SYNCING...';
    if (failed > 0) return '$failed SYNC ERRORS';
    if (pending > 0) return '$pending PENDING SYNC';
    return 'ONLINE';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/api/backend_health_provider.dart';

final syncQueueListProvider = StreamProvider<List<SyncQueueItem>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.syncQueue)
        ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
      .watch()
      .map((rows) => rows.map((row) => row.toSyncQueueItem()).toList());
});

extension on SyncQueueEntity {
  SyncQueueItem toSyncQueueItem() {
    return SyncQueueItem(
      localId: localId,
      serverId: serverId,
      featureName: featureName,
      actionType: actionType,
      payloadJson: payloadJson,
      syncStatus: syncStatus,
      retryCount: retryCount,
      lastError: lastError,
      localVersion: localVersion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class SyncQueuePage extends ConsumerWidget {
  const SyncQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueAsync = ref.watch(syncQueueListProvider);
    final healthAsync = ref.watch(backendHealthProvider);

    String healthStatusStr = "CHECKING HEALTH...";
    Color healthColor = Colors.orange;

    healthAsync.whenData((status) {
      if (status == BackendHealthStatus.online) {
        healthStatusStr = "BACKEND REACHABLE";
        healthColor = Colors.green;
      } else if (status == BackendHealthStatus.backendUnavailable) {
        healthStatusStr = "BACKEND UNAVAILABLE";
        healthColor = Colors.red;
      } else {
        healthStatusStr = "OFFLINE";
        healthColor = Colors.grey;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Synchronization Queue'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(syncRepositoryProvider).clearFailedOperations();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cleared failed sync operations.')),
                );
              }
            },
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear Failed',
          ),
          IconButton(
            onPressed: () => ref.read(syncProcessorProvider).processQueue(),
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Now',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: healthColor.withValues(alpha: 0.15),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 12, color: healthColor),
                const SizedBox(width: 8),
                Text(
                  healthStatusStr,
                  style: TextStyle(fontWeight: FontWeight.bold, color: healthColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: queueAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const AppEmptyView(
                    message: 'No pending synchronization tasks.',
                    icon: Icons.cloud_done_outlined,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _SyncQueueItemTile(item: item);
                  },
                );
              },
              loading: () => const AppLoadingIndicator(),
              error: (e, st) => AppErrorView(message: e.toString()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncQueueItemTile extends StatelessWidget {
  final SyncQueueItem item;

  const _SyncQueueItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        leading: AppSyncStatusIndicator(status: item.syncStatus),
        title: Text(
          '${item.actionType.replaceAll('_', ' ')}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${item.featureName.toUpperCase()} • ${DateFormat.jm().format(item.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          'Retry: ${item.retryCount}',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Local ID', value: item.localId),
                if (item.serverId != null) _InfoRow(label: 'Server ID', value: item.serverId!),
                _InfoRow(label: 'Status', value: item.syncStatus.name.toUpperCase()),
                if (item.lastError != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Last Error:',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.lastError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Payload:',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.payloadJson,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}

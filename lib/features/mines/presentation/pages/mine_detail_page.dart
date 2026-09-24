import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_sync_status_provider.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:intl/intl.dart';

class MineDetailPage extends ConsumerWidget {
  final String mineId;

  const MineDetailPage({super.key, required this.mineId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mineAsync = ref.watch(getMineByIdProvider).call(mineId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mine Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/mines/$mineId/edit'),
          ),
        ],
      ),
      body: FutureBuilder<Mine?>(
        future: mineAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoadingIndicator(message: 'Loading mine details...');
          }

          if (snapshot.hasError) {
            return AppErrorView(message: snapshot.error.toString());
          }

          final mine = snapshot.data;
          if (mine == null) {
            return const AppEmptyView(message: 'Mine not found.');
          }

          return _MineDetailContent(mine: mine);
        },
      ),
    );
  }
}

class _MineDetailContent extends ConsumerWidget {
  final Mine mine;

  const _MineDetailContent({required this.mine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(mineSyncStatusProvider(mine.localId));
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mine.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    _SyncStatusBadge(status: syncStatusAsync.value),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  mine.mineCode,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                ),
                const Divider(height: AppSpacing.lg),
                _DetailRow(label: 'Status', value: mine.status.name.toUpperCase()),
                _DetailRow(
                  label: 'Location',
                  value: '${mine.latitude.toStringAsFixed(6)}, ${mine.longitude.toStringAsFixed(6)}',
                ),
                _DetailRow(label: 'Created', value: dateFormat.format(mine.createdAt)),
                _DetailRow(label: 'Last Updated', value: dateFormat.format(mine.updatedAt)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppSectionHeader(title: 'Technical Info'),
          AppCard(
            child: Column(
              children: [
                _DetailRow(label: 'Local ID', value: mine.localId),
                if (mine.serverId != null)
                  _DetailRow(label: 'Server ID', value: mine.serverId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  final SyncStatus? status;

  const _SyncStatusBadge({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status == SyncStatus.synced) {
      return const AppStatusChip(label: 'Synced', color: Colors.green);
    }

    Color color;
    String label;

    switch (status!) {
      case SyncStatus.pending:
        label = 'Pending Sync';
        color = Colors.grey;
        break;
      case SyncStatus.syncing:
        label = 'Syncing...';
        color = Colors.blue;
        break;
      case SyncStatus.failed:
        label = 'Sync Failed';
        color = Colors.red;
        break;
      case SyncStatus.conflict:
        label = 'Conflict';
        color = Colors.orange;
        break;
      default:
        label = 'Unknown';
        color = Colors.grey;
    }

    return AppStatusChip(label: label, color: color);
  }
}

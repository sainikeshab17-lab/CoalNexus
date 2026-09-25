import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_sync_status_provider.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_providers.dart';
import 'package:intl/intl.dart';

class InspectionListPage extends ConsumerWidget {
  const InspectionListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inspectionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspections'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.read(inspectionRepositoryProvider).refreshInspections();
              ref.read(inspectionListProvider.notifier).loadInspections();
            },
          ),
        ],
      ),
      body: state.when(
        loading: () => const AppLoadingIndicator(message: 'Loading inspections...'),
        error: (err, stack) => AppErrorView(
          message: err.toString(),
          onRetry: () => ref.read(inspectionListProvider.notifier).loadInspections(),
        ),
        data: (inspections) {
          if (inspections.isEmpty) {
            return const AppEmptyView(
              message: 'No inspections found. Start by creating a new one.',
              icon: Icons.assignment_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: inspections.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final inspection = inspections[index];
              return InspectionCard(inspection: inspection);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/inspections/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InspectionCard extends ConsumerWidget {
  final Inspection inspection;

  const InspectionCard({super.key, required this.inspection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mineAsync = ref.watch(getMineByIdProvider).call(inspection.mineId);
    final syncStatusAsync = ref.watch(inspectionSyncStatusProvider(inspection.localId));

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/inspections/${inspection.localId}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FutureBuilder(
                      future: mineAsync,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return Text(
                            snapshot.data!.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        }
                        return const Text('Loading mine...');
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _SyncStatusIcon(status: syncStatusAsync.value),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm').format(inspection.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  _StatusChip(status: inspection.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SyncStatusIcon extends StatelessWidget {
  final SyncStatus? status;

  const _SyncStatusIcon({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status == SyncStatus.synced) return const SizedBox.shrink();

    IconData icon;
    Color color;

    switch (status!) {
      case SyncStatus.pending:
        icon = Icons.cloud_upload_outlined;
        color = Colors.grey;
        break;
      case SyncStatus.syncing:
        icon = Icons.sync;
        color = Colors.blue;
        break;
      case SyncStatus.failed:
        icon = Icons.cloud_off;
        color = Colors.red;
        break;
      case SyncStatus.conflict:
        icon = Icons.warning_amber;
        color = Colors.orange;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Icon(icon, size: 16, color: color);
  }
}

class _StatusChip extends StatelessWidget {
  final InspectionStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case InspectionStatus.draft:
        color = Colors.grey;
        break;
      case InspectionStatus.completed:
        color = Colors.blue;
        break;
      case InspectionStatus.submitted:
        color = Colors.green;
        break;
    }

    return AppStatusChip(label: status.name, color: color);
  }
}

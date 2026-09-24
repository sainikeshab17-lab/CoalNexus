import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection_finding.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_detail_provider.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_sync_status_provider.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/sync/sync_models.dart';
import 'package:intl/intl.dart';

class InspectionDetailPage extends ConsumerWidget {
  final String inspectionId;

  const InspectionDetailPage({super.key, required this.inspectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inspectionDetailProvider(inspectionId));
    final syncStatusAsync = ref.watch(inspectionSyncStatusProvider(inspectionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection Detail'),
        actions: [
          if (syncStatusAsync.value != null && syncStatusAsync.value != SyncStatus.synced)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: _SyncStatusWidget(status: syncStatusAsync.value!),
            ),
        ],
      ),
      body: state.inspection.when(
        loading: () => const AppLoadingIndicator(),
        error: (err, stack) => AppErrorView(
          message: err.toString(),
          onRetry: () => ref.read(inspectionDetailProvider(inspectionId).notifier).loadData(inspectionId),
        ),
        data: (inspection) {
          if (inspection == null) {
            return const AppEmptyView(message: 'Inspection not found');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InspectionHeader(inspection: inspection),
                const SizedBox(height: AppSpacing.lg),
                AppSectionHeader(
                  title: 'Findings',
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => context.push('/inspections/$inspectionId/add_finding'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                state.findings.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('Error loading findings: $err'),
                  data: (findings) {
                    if (findings.isEmpty) {
                      return const Text('No findings added yet.');
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: findings.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final finding = findings[index];
                        return _FindingCard(finding: finding, mineId: inspection.mineId);
                      },
                    );

                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InspectionHeader extends ConsumerWidget {
  final Inspection inspection;

  const _InspectionHeader({required this.inspection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mineAsync = ref.watch(getMineByIdProvider).call(inspection.mineId);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: mineAsync,
            builder: (context, snapshot) {
              return Text(
                snapshot.data?.name ?? 'Loading mine...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              _StatusChip(status: inspection.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Created: ${DateFormat('MMM dd, yyyy HH:mm').format(inspection.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            'Updated: ${DateFormat('MMM dd, yyyy HH:mm').format(inspection.updatedAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _FindingCard extends StatelessWidget {
  final InspectionFinding finding;
  final String mineId;

  const _FindingCard({
    required this.finding,
    required this.mineId,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (finding.status) {
      case FindingStatus.compliant:
        statusColor = Colors.green;
        break;
      case FindingStatus.nonCompliant:
        statusColor = Colors.red;
        break;
      case FindingStatus.notApplicable:
        statusColor = Colors.grey;
        break;
    }

    return AppCard(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  finding.requirementId,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              AppStatusChip(label: finding.status.name, color: statusColor),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            finding.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (finding.status == FindingStatus.nonCompliant) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push(
                    '/violations/create',
                    extra: {
                      'findingId': finding.localId,
                      'inspectionId': finding.inspectionId,
                      'mineId': mineId,
                      'description': finding.description,
                    },
                  );
                },
                icon: const Icon(Icons.gavel_outlined, size: 16),
                label: const Text('Report Violation'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SyncStatusWidget extends StatelessWidget {
  final SyncStatus status;

  const _SyncStatusWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    String label;

    switch (status) {
      case SyncStatus.pending:
        icon = Icons.cloud_upload_outlined;
        color = Colors.grey;
        label = 'Pending';
        break;
      case SyncStatus.syncing:
        icon = Icons.sync;
        color = Colors.blue;
        label = 'Syncing';
        break;
      case SyncStatus.failed:
        icon = Icons.cloud_off;
        color = Colors.red;
        label = 'Failed';
        break;
      case SyncStatus.conflict:
        icon = Icons.warning_amber;
        color = Colors.orange;
        label = 'Conflict';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
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

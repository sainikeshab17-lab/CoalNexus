import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_providers.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_sync_status_provider.dart';

class ViolationDetailPage extends ConsumerWidget {
  final String violationId;

  const ViolationDetailPage({
    super.key,
    required this.violationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final violationAsync = ref.watch(getViolationByIdProvider).call(violationId);
    final syncStatusAsync = ref.watch(violationSyncStatusProvider(violationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Violation Details'),
        actions: [
          syncStatusAsync.when(
            data: (status) => status != null 
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: AppSyncStatusIndicator(status: status),
                  )
                : const SizedBox.shrink(),
            loading: () => const Padding(
              padding: EdgeInsets.only(right: AppSpacing.md),
              child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, _) => const Padding(
              padding: EdgeInsets.only(right: AppSpacing.md),
              child: Icon(Icons.sync_problem, color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/violations/$violationId/edit'),
          ),
        ],
      ),
      body: FutureBuilder<Violation?>(
        future: violationAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AppLoadingIndicator();
          }
          if (snapshot.hasError) {
            return AppErrorView(message: snapshot.error.toString());
          }
          final violation = snapshot.data;
          if (violation == null) {
            return const AppEmptyView(message: 'Violation not found');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ViolationHeader(violation: violation),
                const SizedBox(height: AppSpacing.lg),
                _ViolationContext(violation: violation),
                const SizedBox(height: AppSpacing.lg),
                _ViolationLifecycle(violation: violation),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViolationHeader extends StatelessWidget {
  final Violation violation;

  const _ViolationHeader({required this.violation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            violation.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            violation.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _SeverityBadge(severity: violation.severity),
              const SizedBox(width: AppSpacing.sm),
              _StatusBadge(status: violation.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _ViolationContext extends StatelessWidget {
  final Violation violation;

  const _ViolationContext({required this.violation});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Context'),
          _DetailRow(label: 'Mine ID', value: violation.mineId),
          _DetailRow(label: 'Inspection ID', value: violation.inspectionId),
          _DetailRow(label: 'Finding ID', value: violation.findingId),
          if (violation.assignedTo != null)
            _DetailRow(label: 'Assigned To', value: violation.assignedTo!),
          if (violation.dueDate != null)
            _DetailRow(
              label: 'Due Date',
              value: DateFormat.yMMMd().format(violation.dueDate!),
              isError: violation.dueDate!.isBefore(DateTime.now()) && violation.status != ViolationStatus.closed,
            ),
        ],
      ),
    );
  }
}

class _ViolationLifecycle extends StatelessWidget {
  final Violation violation;

  const _ViolationLifecycle({required this.violation});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'History'),
          _DetailRow(label: 'Detected At', value: dateFormat.format(violation.detectedAt)),
          _DetailRow(label: 'Created At', value: dateFormat.format(violation.createdAt)),
          _DetailRow(label: 'Updated At', value: dateFormat.format(violation.updatedAt)),
          _DetailRow(label: 'Local Version', value: violation.localVersion.toString()),
          if (violation.serverId != null)
            _DetailRow(label: 'Server ID', value: violation.serverId!),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isError;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isError ? theme.colorScheme.error : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  final ViolationSeverity severity;

  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (severity) {
      case ViolationSeverity.low: color = Colors.blue; break;
      case ViolationSeverity.medium: color = Colors.orange; break;
      case ViolationSeverity.high: color = Colors.deepOrange; break;
      case ViolationSeverity.critical: color = Colors.red; break;
    }
    return AppStatusChip(label: severity.name.toUpperCase(), color: color);
  }
}

class _StatusBadge extends StatelessWidget {
  final ViolationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case ViolationStatus.detected:
      case ViolationStatus.recorded: color = Colors.grey; break;
      case ViolationStatus.assigned: color = Colors.blue; break;
      case ViolationStatus.correctiveAction: color = Colors.amber; break;
      case ViolationStatus.evidenceSubmitted: color = Colors.purple; break;
      case ViolationStatus.verification: color = Colors.cyan; break;
      case ViolationStatus.closed: color = Colors.green; break;
      case ViolationStatus.overdue: color = Colors.red; break;
    }
    return AppStatusChip(label: status.name.toUpperCase(), color: color);
  }
}

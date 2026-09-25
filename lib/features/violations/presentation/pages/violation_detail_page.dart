import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';
import 'package:coalnexus/core/sync/sync_providers.dart';
import 'package:coalnexus/core/widgets/audit_timeline.dart';
import 'package:coalnexus/core/workflow/workflow_service.dart';
import 'package:coalnexus/features/violations/domain/entities/corrective_action.dart';
import 'package:coalnexus/features/violations/presentation/providers/corrective_action_providers.dart';
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
    final actionsAsync = ref.watch(correctiveActionsForViolationProvider(violationId));
    final auditAsync = ref.watch(auditTrailProvider(violationId));

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
                _CorrectiveActionsSection(
                  violationId: violationId,
                  actionsAsync: actionsAsync,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ViolationWorkflowTransitions(violation: violation),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSectionHeader(title: 'Audit Trail & Workflow History'),
                      const SizedBox(height: AppSpacing.md),
                      auditAsync.when(
                        data: (events) => AuditTimeline(events: events, shrinkWrap: true),
                        loading: () => const AppLoadingIndicator(),
                        error: (e, _) => Text('Error loading audit trail: $e'),
                      ),
                    ],
                  ),
                ),
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

class _CorrectiveActionsSection extends ConsumerWidget {
  final String violationId;
  final AsyncValue<List<CorrectiveAction>> actionsAsync;

  const _CorrectiveActionsSection({
    required this.violationId,
    required this.actionsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: 'Corrective Actions',
            trailing: TextButton.icon(
              onPressed: () => context.push('/violations/$violationId/corrective_action/new'),
              icon: const Icon(Icons.add),
              label: const Text('ADD'),
            ),
          ),
          actionsAsync.when(
            data: (actions) {
              if (actions.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text('No corrective actions defined yet.'),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: actions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(action.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(action.description),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            AppStatusChip(
                              label: action.status.name.toUpperCase(),
                              color: WorkflowService.getStatusColor(action.status),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text('Priority: ${action.priority.toUpperCase()}', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showStatusTransitionDialog(context, ref, action),
                  );
                },
              );
            },
            loading: () => const AppLoadingIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }

  void _showStatusTransitionDialog(BuildContext context, WidgetRef ref, CorrectiveAction action) {
    final authState = ref.read(authNotifierProvider);
    final user = authState.user;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Manage ${action.title}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: CorrectiveActionStatus.values.map((status) {
              final allowedWorkflow = WorkflowService.canTransitionCorrectiveAction(action.status, status);
              
              // RBAC Check
              bool allowedRBAC = true;
              if (status == CorrectiveActionStatus.verified) {
                allowedRBAC = user?.hasPermission(UserPermission.verifyCorrectiveAction) ?? false;
              }
              
              final allowed = allowedWorkflow && allowedRBAC;
              
              return ListTile(
                title: Text(WorkflowService.getStatusLabel(status)),
                leading: Radio<CorrectiveActionStatus>(
                  value: status,
                  groupValue: action.status,
                  onChanged: allowed ? (v) async {
                    Navigator.pop(context);
                    final updated = action.copyWith(status: status, updatedAt: DateTime.now());
                    await ref.read(updateCorrectiveActionProvider).call(updated);
                    ref.invalidate(correctiveActionsForViolationProvider(violationId));
                  } : null,
                ),
                enabled: allowed,
                subtitle: (allowedWorkflow && !allowedRBAC) 
                  ? const Text('Insufficient permissions to verify', style: TextStyle(color: Colors.red, fontSize: 10))
                  : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/violations/$violationId/corrective_action/${action.localId}/edit');
              },
              child: const Text('EDIT DETAILS'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}

class _ViolationWorkflowTransitions extends ConsumerWidget {
  final Violation violation;

  const _ViolationWorkflowTransitions({required this.violation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Workflow Lifecycle States'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ViolationStatus.values.map((status) {
              final isCurrent = violation.status == status;
              // Simple check for allowed state updates
              final isAllowed = !isCurrent && (violation.status.index <= status.index);

              return ChoiceChip(
                label: Text(status.name.toUpperCase()),
                selected: isCurrent,
                selectedColor: Colors.blue.withValues(alpha: 0.2),
                onSelected: isAllowed ? (selected) async {
                  if (selected) {
                    final updated = violation.copyWith(status: status, updatedAt: DateTime.now());
                    await ref.read(updateViolationProvider).call(updated);
                    // Force refresh of future
                    ref.invalidate(getViolationByIdProvider);
                  }
                } : null,
              );
            }).toList(),
          ),
        ],
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

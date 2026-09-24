import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_sync_status_provider.dart';

class ViolationListPage extends ConsumerStatefulWidget {
  const ViolationListPage({super.key});

  @override
  ConsumerState<ViolationListPage> createState() => _ViolationListPageState();
}

class _ViolationListPageState extends ConsumerState<ViolationListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(violationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Violations'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search violations...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(violationListProvider.notifier).setSearchQuery('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                ref.read(violationListProvider.notifier).setSearchQuery(value);
                setState(() {});
              },
            ),
          ),
        ),
      ),
      body: state.when(
        loading: () => const AppLoadingIndicator(message: 'Loading violations...'),
        error: (err, stack) => AppErrorView(
          message: err.toString(),
          onRetry: () => ref.read(violationListProvider.notifier).loadViolations(),
        ),
        data: (violations) {
          if (violations.isEmpty) {
            if (_searchController.text.isNotEmpty) {
              return const AppEmptyView(
                message: 'No violations match your search.',
                icon: Icons.search_off,
              );
            }
            return const AppEmptyView(
              message: 'No violations recorded.',
              icon: Icons.gavel_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.read(violationListProvider.notifier).loadViolations(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: violations.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final violation = violations[index];
                return ViolationCard(violation: violation);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/violations/create'),
        tooltip: 'Report Violation',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ViolationCard extends ConsumerWidget {
  final Violation violation;

  const ViolationCard({super.key, required this.violation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(violationSyncStatusProvider(violation.localId));
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/violations/${violation.localId}'),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      violation.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  syncStatusAsync.when(
                    data: (status) => status != null 
                        ? AppSyncStatusIndicator(status: status)
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (error, stackTrace) => const Icon(Icons.sync_problem, size: 16, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mine ID: ${violation.mineId}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _SeverityChip(severity: violation.severity),
                  const SizedBox(width: AppSpacing.sm),
                  _StatusChip(status: violation.status),
                ],
              ),
              if (violation.dueDate != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${DateFormat.yMMMd().format(violation.dueDate!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: violation.dueDate!.isBefore(DateTime.now()) && 
                               violation.status != ViolationStatus.closed
                            ? theme.colorScheme.error
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SeverityChip extends StatelessWidget {
  final ViolationSeverity severity;

  const _SeverityChip({required this.severity});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (severity) {
      case ViolationSeverity.low:
        color = Colors.blue;
        break;
      case ViolationSeverity.medium:
        color = Colors.orange;
        break;
      case ViolationSeverity.high:
        color = Colors.deepOrange;
        break;
      case ViolationSeverity.critical:
        color = Colors.red;
        break;
    }

    return AppStatusChip(
      label: severity.name.toUpperCase(),
      color: color,
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ViolationStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case ViolationStatus.detected:
      case ViolationStatus.recorded:
        color = Colors.grey;
        break;
      case ViolationStatus.assigned:
        color = Colors.blue;
        break;
      case ViolationStatus.correctiveAction:
        color = Colors.amber;
        break;
      case ViolationStatus.evidenceSubmitted:
        color = Colors.purple;
        break;
      case ViolationStatus.verification:
        color = Colors.cyan;
        break;
      case ViolationStatus.closed:
        color = Colors.green;
        break;
      case ViolationStatus.overdue:
        color = Colors.red;
        break;
    }

    return AppStatusChip(
      label: status.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').toUpperCase(),
      color: color,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/features/mines/domain/entities/mine.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_sync_status_provider.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/iot/presentation/widgets/sensor_monitoring_grid.dart';
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
    final riskAsync = ref.watch(mineRiskProvider(mine.localId));
    final violationsAsync = ref.watch(violationListProvider);
    
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Risk Intelligence Section
          riskAsync.when(
            data: (risk) => _MineRiskCard(risk: risk),
            loading: () => const AppCard(child: Center(child: CircularProgressIndicator())),
            error: (err, _) => AppCard(child: Text('Error loading risk data: $err')),
          ),
          const SizedBox(height: AppSpacing.md),

          const AppSectionHeader(title: 'Live Telemetry'),
          SensorMonitoringGrid(mineId: mine.localId),
          const SizedBox(height: AppSpacing.md),

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
                    if (syncStatusAsync.value != null)
                      AppSyncStatusIndicator(status: syncStatusAsync.value!),
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
          const AppSectionHeader(title: 'Recent Violations'),
          violationsAsync.when(
            data: (violations) {
              final mineViolations = violations.where((v) => v.mineId == mine.localId).toList();
              if (mineViolations.isEmpty) {
                return const AppCard(child: Text('No active violations.'));
              }
              return Column(
                children: mineViolations.take(3).map((v) => Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    title: Text(v.title),
                    subtitle: Text(v.severity.name.toUpperCase()),
                    trailing: _ViolationStatusChip(status: v.status),
                    onTap: () => context.push('/violations/${v.localId}'),
                  ),
                )).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error: $err'),
          ),

          const SizedBox(height: AppSpacing.md),
          const AppSectionHeader(title: 'Administrative Metadata'),
          AppCard(
            child: Column(
              children: [
                _DetailRow(label: 'Mine Registry ID', value: mine.localId.toUpperCase()),
                if (mine.serverId != null)
                  _DetailRow(label: 'Sync Authority ID', value: mine.serverId!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MineRiskCard extends StatelessWidget {
  final MineRisk risk;

  const _MineRiskCard({required this.risk});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (risk.level) {
      case RiskLevel.critical:
        color = Colors.red;
        break;
      case RiskLevel.high:
        color = Colors.orange;
        break;
      case RiskLevel.medium:
        color = Colors.amber;
        break;
      case RiskLevel.low:
        color = Colors.green;
        break;
    }

    return AppCard(
      backgroundColor: color.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SAFETY RISK INTELLIGENCE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              AppStatusChip(label: risk.level.label, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                risk.score.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text('/ 100',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).disabledColor)),
              const Spacer(),
              Text(
                'Updated: ${DateFormat('HH:mm').format(risk.updatedAt)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).disabledColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: risk.score / 100,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Risk Factors Breakdown:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...risk.factors.map((f) => _RiskFactorRow(factor: f, color: color)),
          if (risk.level != RiskLevel.low) ...[
            const Divider(height: AppSpacing.lg),
            _WhyIsThisHighRisk(risk: risk),
          ],
        ],
      ),
    );
  }
}

class _RiskFactorRow extends StatelessWidget {
  final RiskFactor factor;
  final Color color;

  const _RiskFactorRow({required this.factor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                factor.title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '+${factor.weight.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Text(
            factor.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}

class _WhyIsThisHighRisk extends StatelessWidget {
  final MineRisk risk;

  const _WhyIsThisHighRisk({required this.risk});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Why is this mine ${risk.level.name} risk?',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _generateRiskExplanation(risk),
            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  String _generateRiskExplanation(MineRisk risk) {
    if (risk.level == RiskLevel.critical) {
      return 'CRITICAL THREAT: Emergency condition detected (e.g., Methane > 2.0%). Automated safety protocols active. Immediate evacuation or ventilation adjustment required.';
    } else if (risk.level == RiskLevel.high) {
      return 'HIGH RISK: Multiple sensor anomalies or safety violations detected. Operational oversight recommended.';
    } else if (risk.level == RiskLevel.medium) {
      return 'MODERATE RISK: Minor deviations from safety baselines. Corrective action during next shift is advised.';
    }
    return 'SAFE: All systems operating within normal safety envelopes.';
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

class _ViolationStatusChip extends StatelessWidget {
  final ViolationStatus status;

  const _ViolationStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case ViolationStatus.closed:
        color = Colors.green;
        break;
      case ViolationStatus.overdue:
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }

    return AppStatusChip(label: status.name, color: color);
  }
}

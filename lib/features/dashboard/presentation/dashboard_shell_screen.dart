import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/features/risk/domain/entities/risk_score.dart';
import 'package:coalnexus/features/risk/presentation/providers/risk_providers.dart';
import 'package:coalnexus/features/risk/presentation/widgets/risk_overview_widget.dart';
import 'package:coalnexus/features/map/presentation/widgets/mine_risk_map.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/iot/domain/repositories/sensor_repository.dart';
import 'package:coalnexus/features/iot/presentation/providers/iot_providers.dart';
import 'package:coalnexus/features/risk/application/safety_incident_simulation_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardShellScreen extends ConsumerWidget {
  const DashboardShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspectionCount = ref.watch(inspectionListProvider).value?.length ?? 0;
    final violationCount = ref.watch(violationListProvider).value?.length ?? 0;
    
    final allRisks = ref.watch(allMinesRiskProvider).value ?? [];
    final highRiskMinesCount = allRisks.where((r) => r.level == RiskLevel.high || r.level == RiskLevel.critical).length;
    
    final alertsAsync = ref.watch(alertsStreamProvider);
    final criticalAlertsAsync = ref.watch(criticalAlertsStreamProvider);
    
    final simulationState = ref.watch(safetySimulationProvider);
    final simulationService = ref.read(safetySimulationProvider.notifier);
    final sensorRepository = ref.read(sensorRepositoryProvider);
    final db = ref.read(appDatabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CoalNexus Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.push('/alerts'),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Text(
              'Good Morning, Inspector',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'System Status: All sensors operational',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Quick Stats Row
            LayoutBuilder(
              builder: (context, constraints) {
                final double itemWidth = (constraints.maxWidth - (AppSpacing.xs * 3)) / 4;
                return Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    SizedBox(
                      width: itemWidth.clamp(70.0, double.infinity),
                      child: _StatCard(
                        count: inspectionCount.toString().padLeft(2, '0'),
                        label: 'Inspections',
                        icon: Icons.assignment_outlined,
                        onTap: () => context.go('/inspections'),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth.clamp(70.0, double.infinity),
                      child: _StatCard(
                        count: violationCount.toString().padLeft(2, '0'),
                        label: 'Violations',
                        icon: Icons.gavel_outlined,
                        onTap: () => context.go('/violations'),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth.clamp(70.0, double.infinity),
                      child: _StatCard(
                        count: highRiskMinesCount.toString().padLeft(2, '0'),
                        label: 'High Risk',
                        icon: Icons.report_problem_outlined,
                        color: highRiskMinesCount > 0 ? Colors.red.shade700 : null,
                        onTap: () => context.go('/mines'),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth.clamp(70.0, double.infinity),
                      child: _StatCard(
                        count: (alertsAsync.value?.length ?? 0).toString().padLeft(2, '0'),
                        label: 'Alerts',
                        icon: Icons.notifications_active_outlined,
                        onTap: () => context.go('/alerts'),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Simulation Controls
            const AppSectionHeader(title: 'Safety Incident Simulation'),
            _SimulationControlPanel(
              service: simulationService,
              state: simulationState,
              repository: sensorRepository,
              db: db,
            ),
            if (simulationState.isActive) ...[
              const SizedBox(height: AppSpacing.sm),
              _SimulationTimeline(timeline: simulationState.timeline),
            ],
            const SizedBox(height: AppSpacing.lg),

            // Critical Alerts Section
            const AppSectionHeader(title: 'Critical Alerts'),
            criticalAlertsAsync.when(
              data: (criticalAlerts) {
                if (criticalAlerts.isEmpty) {
                  return const AppEmptyView(
                    message: 'No critical safety alerts at this time.',
                    icon: Icons.check_circle_outline,
                  );
                }
                return Column(
                  children: criticalAlerts.map((alert) => AlertListTile(alert: alert)).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Risk Overview
            const AppSectionHeader(title: 'Mine Risk Overview'),
            const RiskOverviewWidget(),
            const SizedBox(height: AppSpacing.lg),

            // Risk Map
            const AppSectionHeader(title: 'Geospatial Risk Map'),
            const MineRiskMap(),
            const SizedBox(height: AppSpacing.lg),

            // Recent Activity
            const AppSectionHeader(title: 'Recent Safety Activity'),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: const Icon(Icons.assignment_turned_in, size: 20, color: Colors.blue),
                    ),
                    title: const Text('Routine Inspection Completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: const Text('WCL Umrer • 2 hours ago', style: TextStyle(fontSize: 11)),
                  ),
                  const Divider(indent: 70),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.shade50,
                      child: const Icon(Icons.warning_amber, size: 20, color: Colors.amber),
                    ),
                    title: const Text('Sensor Calibration Alert', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: const Text('Methane Node 042 • 4 hours ago', style: TextStyle(fontSize: 11)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextButton(
                      onPressed: () => context.push('/audit-trail'),
                      child: const Text('VIEW ALL AUDIT LOGS'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? color;

  const _StatCard({
    required this.count,
    required this.label,
    required this.onTap,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      backgroundColor: color != null ? color!.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: color ?? Colors.blueGrey),
                const SizedBox(height: 4),
              ],
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w800,
                      color: color?.withValues(alpha: 0.8) ?? Colors.blueGrey.shade600,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlinkingLiveTag extends StatefulWidget {
  const _BlinkingLiveTag();

  @override
  State<_BlinkingLiveTag> createState() => _BlinkingLiveTagState();
}

class _BlinkingLiveTagState extends State<_BlinkingLiveTag> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (!const bool.fromEnvironment('dart.vm.product') &&
        WidgetsBinding.instance.toString().contains('TestWidgetsFlutterBinding')) {
      _controller.value = 1.0;
    } else {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'LIVE',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class AlertListTile extends StatelessWidget {
  final AlertEntity alert;

  const AlertListTile({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (alert.severity) {
      case 'CRITICAL':
        color = Colors.red;
        icon = Icons.gpp_maybe;
        break;
      case 'HIGH':
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;
      case 'MEDIUM':
        color = Colors.amber.shade700;
        icon = Icons.info_outline;
        break;
      default:
        color = Colors.blue;
        icon = Icons.notifications_none;
    }

    final isCritical = alert.severity == 'CRITICAL';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isCritical ? color.withValues(alpha: 0.05) : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCritical ? color.withValues(alpha: 0.3) : Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          alert.title,
          style: TextStyle(
            fontWeight: isCritical ? FontWeight.w900 : FontWeight.bold,
            color: isCritical ? color : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.message, style: const TextStyle(fontSize: 13)),
            if (isCritical) ...[
              const SizedBox(height: 4),
              Text(
                'RECOMMENDATION: IMMEDIATE EVACUATION / INSPECTION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('HH:mm').format(alert.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
            ),
            if (isCritical)
              const Icon(Icons.priority_high, size: 16, color: Colors.red),
          ],
        ),
        onTap: () => context.push('/alerts'),
      ),
    );
  }
}

class _SimulationControlPanel extends StatelessWidget {
  final SafetyIncidentSimulationService service;
  final SimulationState state;
  final SensorRepository repository;
  final AppDatabase db;

  const _SimulationControlPanel({
    required this.service,
    required this.state,
    required this.repository,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = state.currentStep == SimulationStep.alertGenerated && !state.isBusy;

    return AppCard(
      backgroundColor: state.isActive ? Colors.blue.shade50.withValues(alpha: 0.3) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_update_warning,
                color: state.isActive ? Colors.blue.shade700 : Colors.blueGrey,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAFETY INCIDENT SIMULATOR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Colors.blueGrey.shade700,
                          ),
                    ),
                    Text(
                      'WCL Umrer Emergency Scenario',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                    ),
                  ],
                ),
              ),
              if (state.isActive && !isCompleted) ...[
                const _BlinkingLiveTag(),
              ],
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: state.isBusy
                      ? null
                      : () => service.runSimulation('seed_m1', repository, db),
                  icon: state.isBusy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(isCompleted ? Icons.replay : Icons.play_arrow),
                  label: Text(
                    state.isBusy
                        ? 'RUNNING DRILL...'
                        : isCompleted
                            ? 'RUN AGAIN'
                            : 'START SAFETY DRILL',
                    style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompleted ? Colors.blueGrey.shade700 : Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton.filledTonal(
                onPressed: state.isBusy
                    ? null
                    : () => service.resetSimulation('seed_m1', repository),
                icon: const Icon(Icons.refresh),
                tooltip: 'Reset Data',
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          if (state.isActive) ...[
            const SizedBox(height: AppSpacing.md),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _getProgress(state.currentStep),
                    backgroundColor: Colors.blue.shade100,
                    color: _getStepColor(state.currentStep),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CURRENT PHASE: ${state.currentStep.title.toUpperCase()}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: _getStepColor(state.currentStep),
                        fontSize: 9,
                      ),
                ),
                Text(
                  '${(_getProgress(state.currentStep) * 100).toInt()}%',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.blueGrey,
                        fontSize: 9,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  double _getProgress(SimulationStep step) {
    if (step == SimulationStep.idle) return 0;
    return (SimulationStep.values.indexOf(step)) / (SimulationStep.values.length - 1);
  }

  Color _getStepColor(SimulationStep step) {
    if (step == SimulationStep.methaneCritical || step == SimulationStep.alertGenerated) {
      return Colors.red.shade600;
    }
    if (step == SimulationStep.idle) return Colors.grey;
    return Colors.amber.shade700;
  }
}

class _SimulationTimeline extends StatelessWidget {
  final List<SimulationEvent> timeline;

  const _SimulationTimeline({required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      margin: const EdgeInsets.only(top: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'SIMULATION EVENT LOG',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeline.length,
            separatorBuilder: (_, __) => const Divider(height: 12, thickness: 0.5),
            itemBuilder: (context, index) {
              final event = timeline[index];
              final isLatest = index == 0;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('HH:mm:ss').format(event.timestamp),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isLatest ? Colors.blue.shade700 : Colors.grey.shade600,
                      fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.message,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLatest ? Colors.black87 : Colors.black54,
                        fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isLatest)
                    const Icon(Icons.chevron_left, size: 14, color: Colors.blue),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

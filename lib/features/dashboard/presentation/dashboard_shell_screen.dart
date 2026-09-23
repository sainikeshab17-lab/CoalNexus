import 'package:flutter/material.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';

class DashboardShellScreen extends StatelessWidget {
  const DashboardShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoalNexus Dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
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

            // Quick Stats Row (Placeholders)
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('04', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Inspections',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('12', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Violations',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('02', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Alerts',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Critical Alerts Section
            const AppSectionHeader(title: 'Critical Alerts'),
            const AppEmptyView(
              message: 'No critical safety alerts at this time.',
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Risk Overview (Architectural Placeholder)
            const AppSectionHeader(title: 'Mine Risk Overview'),
            AppCard(
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: const Center(
                  child: Text('Risk Visualization Placeholder'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Recent Activity
            const AppSectionHeader(title: 'Recent Activity'),
            const AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.assignment_turned_in, size: 20)),
                    title: Text('Inspection Completed'),
                    subtitle: Text('Mine A - 2 hours ago'),
                  ),
                  Divider(),
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.warning_amber, size: 20)),
                    title: Text('New Violation Recorded'),
                    subtitle: Text('Ventilation Anomaly - 4 hours ago'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/features/iot/presentation/providers/iot_providers.dart';
import 'package:intl/intl.dart';

class AlertsPage extends ConsumerStatefulWidget {
  const AlertsPage({super.key});

  @override
  ConsumerState<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends ConsumerState<AlertsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Alerts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search alerts...',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                });
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.orange),
            tooltip: 'Trigger Demo Critical Event',
            onPressed: () {
              // Trigger for the first seeded mine for demo purposes
              ref.read(sensorRepositoryProvider).triggerDemoCriticalValues('seed_m1');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulating critical sensor event at Jharia Coalfield...')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset to Normal',
            onPressed: () {
              ref.read(sensorRepositoryProvider).resetToNormalValues('seed_m1');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sensors reset to normal state.')),
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final alertsAsync = ref.watch(alertsStreamProvider);
          if (alertsAsync.isLoading) {
            return const AppLoadingIndicator(message: 'Loading alerts...');
          }
          final alerts = alertsAsync.value ?? [];
          final filtered = alerts.where((a) {
            if (_searchQuery.isEmpty) return true;
            return a.title.toLowerCase().contains(_searchQuery) ||
                a.message.toLowerCase().contains(_searchQuery) ||
                a.severity.toLowerCase().contains(_searchQuery);
          }).toList();

          if (filtered.isEmpty) {
            return const AppEmptyView(
              message: 'No safety alerts match your criteria.',
              icon: Icons.notifications_off_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final alert = filtered[index];
              Color severityColor;
              switch (alert.severity) {
                case 'CRITICAL':
                  severityColor = Colors.red;
                  break;
                case 'HIGH':
                  severityColor = Colors.orange;
                  break;
                case 'MEDIUM':
                  severityColor = Colors.amber;
                  break;
                default:
                  severityColor = Colors.blue;
              }

              return Opacity(
                opacity: alert.isRead ? 0.6 : 1.0,
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: alert.isRead ? FontWeight.normal : FontWeight.bold,
                                  ),
                            ),
                          ),
                          AppStatusChip(label: alert.severity, color: severityColor),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(alert.message, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy HH:mm').format(alert.createdAt),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (!alert.isRead)
                            TextButton.icon(
                              onPressed: () => db.markAlertAsRead(alert.localId),
                              icon: const Icon(Icons.check_circle_outline, size: 16),
                              label: const Text('Mark as Read', style: TextStyle(fontSize: 12)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';

class ProfileShellScreen extends StatelessWidget {
  const ProfileShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            const AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    child: Icon(Icons.person, size: 32),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rahul Sharma',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Role: Lead Mine Inspector',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        'ID: EMP-26024',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // System Status / Synchronization info
            const AppSectionHeader(title: 'Sync & Device Status'),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.cloud_done_outlined, color: Colors.green),
                    title: const Text('Database Synchronized'),
                    subtitle: const Text('Last sync: Today, 08:30 AM'),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text('Sync Now'),
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.signal_cellular_4_bar, color: Colors.blue),
                    title: Text('Network Connectivity'),
                    subtitle: Text('Online (Server Connected)'),
                  ),
                  const Divider(),
                  const ListTile(
                    leading: Icon(Icons.storage_outlined),
                    title: Text('Pending Queue'),
                    subtitle: Text('0 items remaining in Outbox'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Settings section
            const AppSectionHeader(title: 'Application Preferences'),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: false,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Dark Mode'),
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    value: true,
                    onChanged: (val) {},
                    secondary: const Icon(Icons.wifi_off_outlined),
                    title: const Text('Offline Field Aggregation'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // App details
            Center(
              child: Text(
                'CoalNexus v1.0.0 (SIH 26024 Foundation)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

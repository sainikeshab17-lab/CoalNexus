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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rahul Sharma',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Role: Lead Mine Inspector',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: EMP-26024',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_done_outlined, color: Colors.green),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Database Synchronized',
                                style: TextStyle(fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Last sync: Today, 08:30 AM',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          ),
                          child: const Text('Sync Now'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.signal_cellular_4_bar, color: Colors.blue),
                    title: Text('Network Connectivity', style: TextStyle(fontSize: 14)),
                    subtitle: Text('Online (Server Connected)', style: TextStyle(fontSize: 12)),
                  ),
                  const Divider(),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.storage_outlined),
                    title: Text('Pending Queue', style: TextStyle(fontSize: 14)),
                    subtitle: Text('0 items remaining in Outbox', style: TextStyle(fontSize: 12)),
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

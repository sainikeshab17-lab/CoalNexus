import 'package:flutter/material.dart';
import 'package:coalnexus/core/theme/app_spacing.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';

import 'package:coalnexus/core/theme/theme_provider.dart';

class ProfileShellScreen extends ConsumerWidget {
  const ProfileShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            AppCard(
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    child: Icon(Icons.person, size: 32),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest User',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Role: ${user?.role.name.toUpperCase() ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'ID: ${user?.id ?? 'N/A'}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                          onPressed: () => context.push('/sync'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          ),
                          child: const Text('View Queue'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.signal_cellular_4_bar, color: Colors.blue),
                    title: const Text('Network Connectivity', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Online (Server Connected)', style: TextStyle(fontSize: 12)),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.storage_outlined),
                    title: const Text('Pending Queue', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('0 items remaining in Outbox', style: TextStyle(fontSize: 12)),
                    onTap: () => context.push('/sync'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Audit Section
            const AppSectionHeader(title: 'Compliance & Audit'),
            AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history_outlined),
                title: const Text('System Audit Trail', style: TextStyle(fontSize: 14)),
                subtitle: const Text('Review all recorded compliance activities', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/audit-trail'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Settings section
            const AppSectionHeader(title: 'Application Preferences'),
            AppCard(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).setThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                    secondary: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.dark_mode_outlined,
                    ),
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

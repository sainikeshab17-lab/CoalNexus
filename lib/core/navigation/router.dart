import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/dashboard/presentation/dashboard_shell_screen.dart';
import 'package:coalnexus/features/profile/presentation/profile_shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('CoalNexus Architecture Placeholder: Login Screen'),
          ),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavigationShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardShellScreen(),
          ),
          GoRoute(
            path: '/mines',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Mines Architectural Placeholder (Not Implemented Yet)')),
            ),
          ),
          GoRoute(
            path: '/inspections',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Inspections Architectural Placeholder (Not Implemented Yet)')),
            ),
          ),
          GoRoute(
            path: '/violations',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Violations Architectural Placeholder (Not Implemented Yet)')),
            ),
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Alerts Architectural Placeholder (Not Implemented Yet)')),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileShellScreen(),
          ),
        ],
      ),
    ],
  );
});

class NavigationShell extends StatelessWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/mines')) return 1;
    if (location.startsWith('/inspections')) return 2;
    if (location.startsWith('/violations')) return 3;
    if (location.startsWith('/alerts')) return 4;
    if (location.startsWith('/profile')) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/dashboard');
        break;
      case 1:
        GoRouter.of(context).go('/mines');
        break;
      case 2:
        GoRouter.of(context).go('/inspections');
        break;
      case 3:
        GoRouter.of(context).go('/violations');
        break;
      case 4:
        GoRouter.of(context).go('/alerts');
        break;
      case 5:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth >= 900,
                  selectedIndex: _calculateSelectedIndex(context),
                  onDestinationSelected: (index) => _onItemTapped(index, context),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Icon(Icons.shield, color: Theme.of(context).colorScheme.primary, size: 36),
                  ),
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Dashboard')),
                    NavigationRailDestination(icon: Icon(Icons.layers_outlined), selectedIcon: Icon(Icons.layers), label: Text('Mines')),
                    NavigationRailDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: Text('Inspections')),
                    NavigationRailDestination(icon: Icon(Icons.gavel_outlined), selectedIcon: Icon(Icons.gavel), label: Text('Violations')),
                    NavigationRailDestination(icon: Icon(Icons.warning_amber_outlined), selectedIcon: Icon(Icons.warning), label: Text('Alerts')),
                    NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: SafeArea(child: child)),
              ],
            ),
          );
        }

        return Scaffold(
          body: SafeArea(child: child),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (index) => _onItemTapped(index, context),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
              NavigationDestination(icon: Icon(Icons.layers_outlined), selectedIcon: Icon(Icons.layers), label: 'Mines'),
              NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Inspections'),
              NavigationDestination(icon: Icon(Icons.gavel_outlined), selectedIcon: Icon(Icons.gavel), label: 'Violations'),
              NavigationDestination(icon: Icon(Icons.warning_amber_outlined), selectedIcon: Icon(Icons.warning), label: 'Alerts'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}

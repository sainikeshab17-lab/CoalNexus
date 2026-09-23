import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/auth/presentation/pages/login_page.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';
import 'package:coalnexus/features/dashboard/presentation/dashboard_shell_screen.dart';
import 'package:coalnexus/features/profile/presentation/profile_shell_screen.dart';

import 'package:coalnexus/features/inspections/presentation/pages/inspection_list_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/create_inspection_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/inspection_detail_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/add_finding_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: _RiverpodRouterRefreshListenable(ref),
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';

      if (authState.status == AuthStatus.initializing) return null;

      final isAuthenticated = authState.status == AuthStatus.authenticated;

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
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
            builder: (context, state) => const InspectionListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateInspectionPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InspectionDetailPage(inspectionId: id);
                },
                routes: [
                  GoRoute(
                    path: 'add_finding',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return AddFindingPage(inspectionId: id);
                    },
                  ),
                ],
              ),
            ],
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

class _RiverpodRouterRefreshListenable extends ChangeNotifier {
  _RiverpodRouterRefreshListenable(Ref ref) {
    ref.listen(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

class NavigationShell extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final _ = authState.user; // Reserved for role/permission based destination filtering when needed

    return LayoutBuilder(
      builder: (context, constraints) {
        final destinations = [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Mines',
          ),
          const NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Inspections',
          ),
          const NavigationDestination(
            icon: Icon(Icons.gavel_outlined),
            selectedIcon: Icon(Icons.gavel),
            label: 'Violations',
          ),
          const NavigationDestination(
            icon: Icon(Icons.warning_amber_outlined),
            selectedIcon: Icon(Icons.warning),
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];

        // Conditional display based on user role or permission can be done here if desired.
        // e.g., if (user?.role == UserRole.admin) { ... }

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
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
                        ),
                      ),
                    ),
                  ),
                  destinations: destinations
                      .map((d) => NavigationRailDestination(
                            icon: d.icon,
                            selectedIcon: d.selectedIcon,
                            label: Text(d.label),
                          ))
                      .toList(),
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
            destinations: destinations,
          ),
        );
      },
    );
  }
}


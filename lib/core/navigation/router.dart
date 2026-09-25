import 'package:coalnexus/features/violations/presentation/pages/corrective_action_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coalnexus/features/auth/presentation/pages/login_page.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';
import 'package:coalnexus/features/dashboard/presentation/dashboard_shell_screen.dart';
import 'package:coalnexus/features/inspections/presentation/pages/add_finding_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/create_inspection_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/inspection_detail_page.dart';
import 'package:coalnexus/features/inspections/presentation/pages/inspection_list_page.dart';
import 'package:coalnexus/features/mines/presentation/pages/create_mine_page.dart';
import 'package:coalnexus/features/mines/presentation/pages/edit_mine_page.dart';
import 'package:coalnexus/features/mines/presentation/pages/mine_detail_page.dart';
import 'package:coalnexus/features/mines/presentation/pages/mine_list_page.dart';
import 'package:coalnexus/features/violations/presentation/pages/violation_list_page.dart';
import 'package:coalnexus/features/violations/presentation/pages/violation_detail_page.dart';
import 'package:coalnexus/features/violations/presentation/pages/create_violation_page.dart';
import 'package:coalnexus/features/violations/presentation/pages/edit_violation_page.dart';
import 'package:coalnexus/features/notifications/presentation/alerts_page.dart';
import 'package:coalnexus/features/profile/presentation/profile_shell_screen.dart';
import 'package:coalnexus/core/sync/presentation/pages/sync_queue_page.dart';
import 'package:coalnexus/core/sync/presentation/pages/audit_trail_page.dart';
import 'package:coalnexus/core/sync/presentation/widgets/sync_status_overlay.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _RiverpodRouterRefreshListenable(ref);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    refreshListenable: listenable,

    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);

      final isLoggingIn = state.uri.path == '/login';

      if (authState.status == AuthStatus.initializing) {
        return null;
      }

      final isAuthenticated =
          authState.status == AuthStatus.authenticated;

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      // ----------------------------------------------------------------------
      // Authentication
      // ----------------------------------------------------------------------
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      // ----------------------------------------------------------------------
      // Main application shell
      // ----------------------------------------------------------------------
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return NavigationShell(child: child);
        },
        routes: [
          // ------------------------------------------------------------------
          // Dashboard
          // ------------------------------------------------------------------
          GoRoute(
            path: '/dashboard',
            builder: (context, state) =>
            const DashboardShellScreen(),
          ),

          // ------------------------------------------------------------------
          // Mines
          // ------------------------------------------------------------------
          GoRoute(
            path: '/mines',
            builder: (context, state) => const MineListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateMinePage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return MineDetailPage(mineId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditMinePage(mineId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // Inspections
          // ------------------------------------------------------------------
          GoRoute(
            path: '/inspections',
            builder: (context, state) =>
            const InspectionListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) =>
                const CreateInspectionPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;

                  return InspectionDetailPage(
                    inspectionId: id,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'add_finding',
                    builder: (context, state) {
                      final id =
                      state.pathParameters['id']!;

                      return AddFindingPage(
                        inspectionId: id,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // Violations
          // ------------------------------------------------------------------
          GoRoute(
            path: '/violations',
            builder: (context, state) => const ViolationListPage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  return CreateViolationPage(initialData: extra);
                },
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ViolationDetailPage(violationId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditViolationPage(violationId: id);
                    },
                  ),
                  GoRoute(
                    path: 'corrective_action/new',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return CorrectiveActionFormPage(violationId: id);
                    },
                  ),
                  GoRoute(
                    path: 'corrective_action/:actionId/edit',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final actionId = state.pathParameters['actionId']!;
                      return CorrectiveActionFormPage(violationId: id, actionId: actionId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // ------------------------------------------------------------------
          // Alerts
          // ------------------------------------------------------------------
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsPage(),
          ),

          // ------------------------------------------------------------------
          // Profile
          // ------------------------------------------------------------------
          GoRoute(
            path: '/profile',
            builder: (context, state) =>
            const ProfileShellScreen(),
          ),

          // ------------------------------------------------------------------
          // Sync
          // ------------------------------------------------------------------
          GoRoute(
            path: '/sync',
            builder: (context, state) => const SyncQueuePage(),
          ),

          // ------------------------------------------------------------------
          // Audit Trail
          // ------------------------------------------------------------------
          GoRoute(
            path: '/audit-trail',
            builder: (context, state) => const AuditTrailPage(),
          ),
        ],
      ),
    ],
  );
});

/// Rebuilds GoRouter's redirect logic when authentication state changes,
/// without recreating the GoRouter instance itself.
class _RiverpodRouterRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription _subscription;

  _RiverpodRouterRefreshListenable(Ref ref) {
    _subscription = ref.listen(authNotifierProvider, (previous, current) {
      notifyListeners();
    });
    
    ref.onDispose(() {
      _subscription.close();
    });
  }
}

/// Main responsive navigation shell.
class NavigationShell extends ConsumerWidget {
  final Widget child;

  const NavigationShell({
    super.key,
    required this.child,
  });

  int _calculateSelectedIndex(BuildContext context) {
    try {
      final location =
          GoRouterState.of(context).uri.path;

      if (location.startsWith('/dashboard')) {
        return 0;
      }

      if (location.startsWith('/mines')) {
        return 1;
      }

      if (location.startsWith('/inspections')) {
        return 2;
      }

      if (location.startsWith('/violations')) {
        return 3;
      }

      if (location.startsWith('/alerts')) {
        return 4;
      }

      if (location.startsWith('/audit-trail')) {
        return 5;
      }

      if (location.startsWith('/profile')) {
        return 6;
      }
    } catch (_) {
      // Fallback for tests or contexts without an active route.
      return 0;
    }

    return 0;
  }

  void _onItemTapped(
      int index,
      BuildContext context,
      ) {
    final router = GoRouter.of(context);

    switch (index) {
      case 0:
        router.go('/dashboard');
        break;

      case 1:
        router.go('/mines');
        break;

      case 2:
        router.go('/inspections');
        break;

      case 3:
        router.go('/violations');
        break;

      case 4:
        router.go('/alerts');
        break;

      case 5:
        router.go('/audit-trail');
        break;

      case 6:
        router.go('/profile');
        break;
    }
  }

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final width = MediaQuery.sizeOf(context).width;

    final isTablet = width >= 600;
    final isDesktop = width >= 900;

    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard),
        label: 'Home',
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
        icon: Icon(Icons.history_outlined),
        selectedIcon: Icon(Icons.history),
        label: 'Audit',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // ------------------------------------------------------------------------
    // Tablet / Desktop
    // ------------------------------------------------------------------------
    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: isDesktop,
              selectedIndex:
              _calculateSelectedIndex(context),
              onDestinationSelected: (index) {
                _onItemTapped(index, context);
              },
              leading: Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                child: Icon(
                  Icons.shield,
                  color:
                  Theme.of(context)
                      .colorScheme
                      .primary,
                  size: 36,
                ),
              ),
              trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.logout,
                      ),
                      onPressed: () {
                        ref
                            .read(
                          authNotifierProvider
                              .notifier,
                        )
                            .logout();
                      },
                    ),
                  ),
                ),
              ),
              destinations: destinations
                  .map(
                    (destination) =>
                    NavigationRailDestination(
                      icon: destination.icon,
                      selectedIcon:
                      destination.selectedIcon,
                      label: Text(
                        destination.label,
                      ),
                    ),
              )
                  .toList(),
            ),

            const VerticalDivider(
              thickness: 1,
              width: 1,
            ),

            Expanded(
              child: SafeArea(
                child: child,
              ),
            ),
          ],
        ),
      );
    }

    // ------------------------------------------------------------------------
    // Mobile
    // ------------------------------------------------------------------------
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: child,
          ),
          const SyncStatusOverlay(),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxWidth < 380;

          return NavigationBar(
            selectedIndex:
            _calculateSelectedIndex(context),
            onDestinationSelected: (index) {
              _onItemTapped(index, context);
            },
            destinations: destinations,
            labelBehavior: isCompact
                ? NavigationDestinationLabelBehavior
                .alwaysHide
                : NavigationDestinationLabelBehavior
                .onlyShowSelected,
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/navigation/router.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';

class FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return AuthState.authenticated(
      const User(
        id: '1',
        name: 'Rahul Sharma',
        email: 'rahul@coalnexus.gov',
        role: UserRole.inspector,
        permissions: {},
      ),
    );
  }
}

class FakeInspectionListNotifier extends InspectionListNotifier {
  @override
  AsyncValue<List<Inspection>> build() {
    return const AsyncValue.data([]);
  }
}

void main() {
  testWidgets('Navigation stability and layout regression test on narrow screens (320x700)', (WidgetTester tester) async {
    // Configure viewport size to narrowest target constraint
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authNotifierProvider.overrideWith(() => FakeAuthNotifier()),
          inspectionListProvider.overrideWith(() => FakeInspectionListNotifier()),
        ],
        child: Consumer(
          builder: (context, ref, child) {
            final router = ref.watch(routerProvider);
            return MaterialApp.router(
              routerConfig: router,
            );
          },
        ),
      ),
    );

    // 1. App Startup validation
    await tester.pumpAndSettle();
    expect(find.text('Good Morning, Inspector'), findsOneWidget);

    // Helper function to tap navigation items securely
    Future<void> navigateTo(IconData icon) async {
      final finder = find.byIcon(icon);
      expect(finder, findsAtLeastNWidgets(1));
      await tester.tap(finder.first);
      await tester.pumpAndSettle();
    }

    // 2. Dashboard -> Mines
    await navigateTo(Icons.layers_outlined);
    expect(find.text('Mines management is coming soon.'), findsOneWidget);

    // 3. Mines -> Inspections
    await navigateTo(Icons.assignment_outlined);
    expect(find.text('Inspections'), findsAtLeastNWidgets(1)); // AppBar title and bottom navigation label

    // 4. Inspections -> Violations
    await navigateTo(Icons.gavel_outlined);
    expect(find.text('Violations tracking is coming soon.'), findsOneWidget);

    // 5. Violations -> Alerts
    await navigateTo(Icons.warning_amber_outlined);
    expect(find.text('Safety alerts are coming soon.'), findsOneWidget);

    // 6. Alerts -> Profile
    await navigateTo(Icons.person_outline);
    expect(find.text('Rahul Sharma'), findsOneWidget);

    // 7. Profile -> Dashboard
    await navigateTo(Icons.dashboard_outlined);
    expect(find.text('Good Morning, Inspector'), findsOneWidget);

    // 8. Repeated switching to verify GlobalKey & RenderPadding stability
    for (int i = 0; i < 3; i++) {
      await navigateTo(Icons.layers_outlined);
      await navigateTo(Icons.assignment_outlined);
      await navigateTo(Icons.dashboard_outlined);
    }

    expect(find.text('Good Morning, Inspector'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}

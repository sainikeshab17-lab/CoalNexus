import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/navigation/router.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';
import 'package:coalnexus/features/inspections/domain/entities/inspection.dart';
import 'package:coalnexus/features/inspections/presentation/providers/inspection_list_provider.dart';
import 'package:coalnexus/features/violations/domain/entities/violation.dart';
import 'package:coalnexus/features/violations/presentation/providers/violation_list_provider.dart';

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

class FakeViolationListNotifier extends ViolationListNotifier {
  @override
  AsyncValue<List<Violation>> build() {
    return const AsyncValue.data([]);
  }
}

void main() {
  testWidgets(
    'Navigation stability and layout regression test on narrow screens (320x700)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => FakeAuthNotifier()),
            inspectionListProvider
                .overrideWith(() => FakeInspectionListNotifier()),
            violationListProvider.overrideWith(() => FakeViolationListNotifier()),
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

      // Allow initial route to build without waiting for
      // every animation/frame in the application to settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Good Morning, Inspector'), findsOneWidget);

      Future<void> navigateTo(IconData icon) async {
        final finder = find.byIcon(icon);

        expect(finder, findsAtLeastNWidgets(1));

        await tester.tap(finder.first);

        // Give GoRouter and the destination page time to build.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      }

      // Dashboard -> Mines
      await navigateTo(Icons.layers_outlined);

      // Mine Management is now implemented.
      expect(find.text('Mines'), findsAtLeastNWidgets(1));

      // Mines -> Inspections
      await navigateTo(Icons.assignment_outlined);
      expect(find.text('Inspections'), findsAtLeastNWidgets(1));

      // Inspections -> Violations
      await navigateTo(Icons.gavel_outlined);
      expect(find.text('Violations'), findsAtLeastNWidgets(1));

      // Violations -> Alerts
      await navigateTo(Icons.warning_amber_outlined);
      expect(find.text('Safety alerts are coming soon.'), findsOneWidget);

      // Alerts -> Profile
      await navigateTo(Icons.person_outline);
      expect(find.text('Rahul Sharma'), findsOneWidget);

      // Profile -> Dashboard
      await navigateTo(Icons.dashboard_outlined);
      expect(find.text('Good Morning, Inspector'), findsOneWidget);

      // Repeated switching to verify navigation stability.
      for (int i = 0; i < 3; i++) {
        await navigateTo(Icons.layers_outlined);
        await navigateTo(Icons.assignment_outlined);
        await navigateTo(Icons.dashboard_outlined);
      }

      expect(find.text('Good Morning, Inspector'), findsOneWidget);
    },
  );
}

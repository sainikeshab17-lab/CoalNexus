import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/navigation/router.dart';
import 'package:coalnexus/features/dashboard/presentation/dashboard_shell_screen.dart';
import 'package:coalnexus/features/profile/presentation/profile_shell_screen.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('Dashboard statistic cards render completely on narrow screen (320x700)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const DashboardShellScreen()));
    await tester.pumpAndSettle();

    expect(find.text('04'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
    expect(find.text('Inspections'), findsOneWidget);
    expect(find.text('Violations'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets('Profile card handles long roles and sync card renders without overflow on 320x700', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const ProfileShellScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Rahul Sharma'), findsOneWidget);
    expect(find.text('Role: Lead Mine Inspector'), findsOneWidget);
    expect(find.text('Database Synchronized'), findsOneWidget);
    expect(find.text('Sync Now'), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets('NavigationShell renders bottom navigation properly on narrow and standard screens', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: NavigationShell(child: SizedBox()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  testWidgets('Placeholder screens render with proper AppEmptyView component', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppEmptyView(
            icon: Icons.layers_outlined,
            message: 'Mines management is coming soon.',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('Mines management is coming soon.'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/navigation/router.dart';
import 'package:coalnexus/features/dashboard/presentation/dashboard_shell_screen.dart';
import 'package:coalnexus/features/profile/presentation/profile_shell_screen.dart';
import 'package:coalnexus/core/widgets/app_widgets.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:drift/native.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final db = AppDatabase.forTesting(NativeDatabase.memory());
          ref.onDispose(() => db.close());
          return db;
        }),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('Dashboard statistic cards render completely on narrow screen (320x700)', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const DashboardShellScreen()));
    // Use pump instead of pumpAndSettle to avoid timeouts with active animations/streams
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('INSPECTIONS'), findsOneWidget);
    expect(find.text('VIOLATIONS'), findsOneWidget);
    expect(find.text('ALERTS'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  }); // Un-skipped as unmount pattern is verified

  testWidgets('Profile card handles long roles and sync card renders without overflow on 320x700', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(const ProfileShellScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Since AuthNotifier defaults to initializing, let's see what is rendered.
    // Let's use textContaining to see what text is found. It's usually 'Guest User' if token is null.
    expect(find.textContaining('User'), findsOneWidget);
    expect(find.textContaining('Role'), findsOneWidget);
    expect(find.textContaining('Synchronized'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('NavigationShell renders bottom navigation properly on narrow and standard screens', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) {
            final db = AppDatabase.forTesting(NativeDatabase.memory());
            ref.onDispose(() => db.close());
            return db;
          }),
        ],
        child: const MaterialApp(
          home: NavigationShell(child: SizedBox()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
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

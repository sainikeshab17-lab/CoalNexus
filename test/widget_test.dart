import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:drift/native.dart';

void main() {
  testWidgets('App Shell Bootstraps Successfully Smoke Test', (WidgetTester tester) async {
    // Build our app under ProviderScope and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) {
            final db = AppDatabase.forTesting(NativeDatabase.memory());
            ref.onDispose(() => db.close());
            return db;
          }),
        ],
        child: const CoalNexusApp(),
      ),
    );

    // Verify that our dashboard screen placeholder mounts successfully.
    expect(find.text('CoalNexus Dashboard'), findsOneWidget);

    // Explicitly unmount the app to trigger disposal before the test ends
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}

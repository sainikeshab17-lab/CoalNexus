import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coalnexus/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/features/mines/presentation/providers/mine_providers.dart';
import 'package:coalnexus/core/storage/local_database.dart';
import 'package:coalnexus/core/sync/sync_websocket_client.dart';
import 'package:coalnexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';
import 'package:coalnexus/shared/domain/entities/user.dart' as entity;
import 'package:drift/native.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class FakeAuthRepository implements AuthRepository {
  @override
  Future<entity.User> login(String username, String password) async {
    return const entity.User(
      id: 'test-user',
      name: 'TEST USER',
      email: 'test@example.com',
      role: entity.UserRole.inspector,
      permissions: {},
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<entity.User?> getCurrentUser() async {
    return const entity.User(
      id: 'test-user',
      name: 'TEST USER',
      email: 'test@example.com',
      role: entity.UserRole.inspector,
      permissions: {},
    );
  }

  @override
  Future<bool> isAuthenticated() async => true;

  @override
  Future<entity.User> refreshSession() async => (await getCurrentUser())!;
}

void main() {
  setUpAll(() async {
    // Initialize Supabase in a mock way for testing if needed
    // But since we are overriding the provider, it might not be strictly necessary
    // unless the app code calls Supabase.instance directly outside the repo.
  });

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
          syncWebSocketClientProvider.overrideWith((ref) => FakeSyncWebSocketClient()),
          authRepositoryProvider.overrideWith((ref) => FakeAuthRepository()),
        ],
        child: const CoalNexusApp(),
      ),
    );

    // Verify that our dashboard screen placeholder mounts successfully.
    // The test might fail because it starts at login or somewhere else if not authenticated
    // But our FakeAuthRepository says isAuthenticated() is true.
    
    await tester.pumpAndSettle();

    expect(find.text('CoalNexus Dashboard'), findsOneWidget);

    // Explicitly unmount the app to trigger disposal before the test ends
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 100));
  });
}

class FakeSyncWebSocketClient implements SyncWebSocketClient {
  @override
  void connect() {}
  @override
  void dispose() {}
}

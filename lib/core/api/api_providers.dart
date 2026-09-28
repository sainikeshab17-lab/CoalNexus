import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/api/api_client.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(
    tokenStorage: tokenStorage,
    onRefreshToken: () async {
      try {
        await ref.read(authRepositoryProvider).refreshSession();
      } catch (e) {
        print('[AUTH_SYNC] Error in apiClient refreshSession: $e');
        // If refresh fails, we might want to logout, but we'll let the next 401 handle it
      }
    },
  );
});


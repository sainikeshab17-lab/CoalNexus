import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/api/api_client.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_provider.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(tokenStorage: tokenStorage);
});


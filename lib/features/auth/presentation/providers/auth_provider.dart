import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/core/storage/token_storage.dart';
import 'package:coalnexus/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:coalnexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:coalnexus/features/auth/presentation/providers/auth_state.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return const SecureTokenStorageImpl(FlutterSecureStorage());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return AuthRepositoryImpl(storage);
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _repository;

  @override
  AuthState build() {
    _repository = ref.watch(authRepositoryProvider);
    _init();
    return AuthState.initializing();
  }

  Future<void> _init() async {
    try {
      final authenticated = await _repository.isAuthenticated();
      if (authenticated) {
        final user = await _repository.getCurrentUser();
        if (user != null) {
          state = AuthState.authenticated(user);
          return;
        }
      }
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.failure('Failed to initialize session');
    }
  }

  Future<void> login(String username, String password) async {
    state = AuthState.authenticating();
    try {
      final user = await _repository.login(username, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.failure(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      state = AuthState.unauthenticated();
    }
  }
}

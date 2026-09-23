
import 'package:coalnexus/core/storage/token_storage.dart';
import 'package:coalnexus/features/auth/data/models/user_model.dart';
import 'package:coalnexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenStorage _tokenStorage;

  // For presentation demonstration/development mode without a live backend backend,
  // we store a local reference or map.
  User? _currentUser;

  AuthRepositoryImpl(this._tokenStorage);

  @override
  Future<User> login(String username, String password) async {
    // Basic validation / trim
    final emailTrimmed = username.trim().toLowerCase();
    
    if (emailTrimmed.isEmpty || password.isEmpty) {
      throw Exception('Username and password are required');
    }

    if (password.length < 6) {
      throw Exception('Invalid credentials');
    }

    // Role simulation based on keywords in email/username
    UserRole role = UserRole.inspector;
    Set<UserPermission> permissions = {
      UserPermission.viewDashboard,
      UserPermission.viewMine,
      UserPermission.createInspection,
      UserPermission.submitInspection,
      UserPermission.viewViolation,
    };

    if (emailTrimmed.contains('admin')) {
      role = UserRole.admin;
      permissions = UserPermission.values.toSet();
    } else if (emailTrimmed.contains('manager')) {
      role = UserRole.manager;
      permissions = {
        UserPermission.viewDashboard,
        UserPermission.viewMine,
        UserPermission.viewViolation,
        UserPermission.createViolation,
        UserPermission.assignCorrectiveAction,
        UserPermission.verifyCorrectiveAction,
        UserPermission.viewRisk,
      };
    }

    final user = UserModel(
      id: 'usr_${emailTrimmed.hashCode.abs()}',
      name: emailTrimmed.split('@').first.toUpperCase(),
      email: emailTrimmed,
      role: role,
      permissions: permissions,
      isActive: true,
    );

    // Store tokens securely
    await _tokenStorage.saveAccessToken('mock_access_token_${user.id}');
    await _tokenStorage.saveRefreshToken('mock_refresh_token_${user.id}');

    // Simulate serializing/storing user metadata if needed, but here we keep in memory
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clear();
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    final token = await _tokenStorage.getAccessToken();
    if (token == null) return null;

    // Simulate recovery from token or cached profile
    // In production this might read from local db or decode non-sensitive JWT claims.
    // For development, reconstruct an inspector user using the token suffix
    final parts = token.split('_');
    final id = parts.isNotEmpty ? parts.last : 'recovered_user';

    _currentUser = UserModel(
      id: id,
      name: 'OPERATOR',
      email: 'operator@coalnexus.gov.in',
      role: UserRole.inspector,
      permissions: const {
        UserPermission.viewDashboard,
        UserPermission.viewMine,
        UserPermission.createInspection,
        UserPermission.submitInspection,
        UserPermission.viewViolation,
      },
      isActive: true,
    );
    return _currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<User> refreshSession() async {
    final user = await getCurrentUser();
    if (user == null) throw Exception('No session to refresh');
    return user;
  }
}

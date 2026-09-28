import 'dart:convert';
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

    // Store tokens securely with structured JWT for backend/offline compatibility
    final accessToken = _createMockJwt(user.id, user.email, user.role.name);
    await _tokenStorage.saveAccessToken(accessToken);
    await _tokenStorage.saveRefreshToken('mock_refresh_token_${user.id}');

    // Simulate serializing/storing user metadata if needed, but here we keep in memory
    _currentUser = user;
    return user;
  }

  String _createMockJwt(String userId, String email, String role) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final payload = {
      'sub': userId,
      'email': email,
      'role': role,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    };

    final headerBase64 =
        base64Url.encode(utf8.encode(jsonEncode(header))).replaceAll('=', '');
    final payloadBase64 =
        base64Url.encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');
    final signatureBase64 =
        base64Url.encode(utf8.encode('mock_signature')).replaceAll('=', '');

    return '$headerBase64.$payloadBase64.$signatureBase64';
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

    String id = 'recovered_user';
    String email = 'operator@coalnexus.gov.in';
    UserRole role = UserRole.inspector;

    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        var payloadPart = parts[1];
        // Normalize padding for base64url
        while (payloadPart.length % 4 != 0) {
          payloadPart += '=';
        }
        final payloadJson = utf8.decode(base64Url.decode(payloadPart));
        final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
        id = payload['sub'] as String? ?? id;
        email = payload['email'] as String? ?? email;
        final roleStr = payload['role'] as String?;
        if (roleStr != null) {
          role = UserRole.values.firstWhere(
            (e) => e.name.toLowerCase() == roleStr.toLowerCase(),
            orElse: () => UserRole.inspector,
          );
        }
      } else {
        // Fallback for old token formats
        final partsOld = token.split('_');
        id = partsOld.isNotEmpty ? partsOld.last : 'recovered_user';
      }
    } catch (e) {
      // Log and fallback
      print('[AUTH_SYNC] Token recovery error: $e');
      final partsOld = token.split('_');
      id = partsOld.isNotEmpty ? partsOld.last : 'recovered_user';
    }

    // Role simulation based on recovered role
    Set<UserPermission> permissions = {
      UserPermission.viewDashboard,
      UserPermission.viewMine,
      UserPermission.createInspection,
      UserPermission.submitInspection,
      UserPermission.viewViolation,
    };

    if (role == UserRole.admin) {
      permissions = UserPermission.values.toSet();
    } else if (role == UserRole.manager) {
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

    _currentUser = UserModel(
      id: id,
      name: email.split('@').first.toUpperCase(),
      email: email,
      role: role,
      permissions: permissions,
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

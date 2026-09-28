import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:coalnexus/core/storage/token_storage.dart';
import 'package:coalnexus/features/auth/data/models/user_model.dart';
import 'package:coalnexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final TokenStorage _tokenStorage;
  final supabase.SupabaseClient _supabaseClient;

  // For presentation demonstration/development mode without a live backend backend,
  // we store a local reference or map.
  User? _currentUser;

  AuthRepositoryImpl(this._tokenStorage, {supabase.SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? supabase.Supabase.instance.client;

  @override
  Future<User> login(String username, String password) async {
    // Basic validation / trim
    final emailTrimmed = username.trim().toLowerCase();

    if (emailTrimmed.isEmpty || password.isEmpty) {
      throw Exception('Username and password are required');
    }

    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: emailTrimmed,
        password: password,
      );

      final session = response.session;
      final supabaseUser = response.user;

      if (session == null || supabaseUser == null) {
        throw Exception('Login failed: Invalid session');
      }

      // Store authentic tokens
      await _tokenStorage.saveAccessToken(session.accessToken);
      await _tokenStorage.saveRefreshToken(session.refreshToken ?? '');

      final user = _mapSupabaseUserToEntity(supabaseUser);
      _currentUser = user;
      return user;
    } on supabase.AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred during login');
    }
  }

  User _mapSupabaseUserToEntity(supabase.User supabaseUser) {
    final metadata = supabaseUser.userMetadata ?? {};
    final roleStr = metadata['role'] as String? ?? 'inspector';
    
    UserRole role = UserRole.inspector;
    if (roleStr.toLowerCase() == 'admin') {
      role = UserRole.admin;
    } else if (roleStr.toLowerCase() == 'manager') {
      role = UserRole.manager;
    }

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

    return UserModel(
      id: supabaseUser.id,
      name: metadata['full_name'] as String? ?? supabaseUser.email?.split('@').first.toUpperCase() ?? 'USER',
      email: supabaseUser.email ?? '',
      role: role,
      permissions: permissions,
      isActive: true,
    );
  }

  @override
  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
    await _tokenStorage.clear();
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    
    final supabaseUser = _supabaseClient.auth.currentUser;
    if (supabaseUser == null) {
      // Try to recover from token storage if session is still valid but not in memory
      final session = _supabaseClient.auth.currentSession;
      if (session != null) {
        _currentUser = _mapSupabaseUserToEntity(session.user);
        return _currentUser;
      }
      return null;
    }

    _currentUser = _mapSupabaseUserToEntity(supabaseUser);
    return _currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _supabaseClient.auth.currentSession != null;
  }

  @override
  Future<User> refreshSession() async {
    try {
      final response = await _supabaseClient.auth.refreshSession();
      final session = response.session;
      final supabaseUser = response.user;

      if (session == null || supabaseUser == null) {
        throw Exception('Session refresh failed');
      }

      await _tokenStorage.saveAccessToken(session.accessToken);
      await _tokenStorage.saveRefreshToken(session.refreshToken ?? '');

      final user = _mapSupabaseUserToEntity(supabaseUser);
      _currentUser = user;
      return user;
    } on supabase.AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An unexpected error occurred during session refresh');
    }
  }
}

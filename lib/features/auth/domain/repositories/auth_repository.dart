import 'package:coalnexus/shared/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<User> refreshSession();
}

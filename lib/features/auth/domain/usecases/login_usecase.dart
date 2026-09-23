import 'package:coalnexus/features/auth/domain/repositories/auth_repository.dart';
import 'package:coalnexus/shared/domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<User> call(String username, String password) {
    return _repository.login(username, password);
  }
}

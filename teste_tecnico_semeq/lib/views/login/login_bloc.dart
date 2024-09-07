import 'package:teste_tecnico_semeq/repositories/entities/login_entity.dart';
import 'package:teste_tecnico_semeq/repositories/login_repository.dart';

abstract class ILoginBloc {
  Future login(LoginEntity user);
}

class LoginBloc implements ILoginBloc {
  final ILoginRepository _loginRepository;
  LoginBloc(this._loginRepository);

  @override
  Future login(LoginEntity user) async {
    try {
      final validUser = await _loginRepository.login(user);
      return validUser;
    } catch (e) {
      return LoginEntity(username: '', password: '');
    }
  }
}

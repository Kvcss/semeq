import 'package:dio/dio.dart';
import 'package:teste_tecnico_semeq/repositories/entities/login_entity.dart';

abstract class ILoginRepository {
  Future<String?> login(LoginEntity user); 
}

class LoginRepository implements ILoginRepository {
  @override
  Future<String?> login(LoginEntity user) async {
    Response response;
    var dio = Dio();
    
    try {
      response = await dio.post(
        'https://apitestemobile-production.up.railway.app/login',
        data: {
          'username': user.username,
          'password': user.password
        },
      );

      if (response.statusCode == 200) {
        var data = response.data as Map<String, dynamic>; 
        return data['access_token']; 
      } else {
        return null; 
      }
    } catch (e) {
      print("Erro durante o login: $e");
      return null;
    }
  }
}

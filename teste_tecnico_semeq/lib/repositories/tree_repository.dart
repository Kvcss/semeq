import 'package:dio/dio.dart';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';

abstract class ITreeRepository {
  Future<List<TreeEntity>> getTree(String accessToken);
  Future<void> editTreeItem(String accessToken, int id, String newName);  
}

class TreeRepository implements ITreeRepository {
  @override
  Future<List<TreeEntity>> getTree(String accessToken) async {
    var dio = Dio();

    try {
      Response response = await dio.get(
        'https://apitestemobile-production.up.railway.app/tree',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => TreeEntity.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os equipamentos');
      }
    } catch (e) {
      throw Exception('Erro ao carregar os equipamentos: $e');
    }
  }

  @override
  Future<void> editTreeItem(String accessToken, int id, String newName) async {
    var dio = Dio();

    try {
      Response response = await dio.post(
        'https://apitestemobile-production.up.railway.app/tree',
        data: {
          'id': id,
          'name': newName,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao editar o equipamento');
      }
    } catch (e) {
      throw Exception('Erro ao editar o equipamento: $e');
    }
  }
}

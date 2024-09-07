import 'package:dio/dio.dart';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';

abstract class ITreeRepository{
  Future<List<TreeEntity>> getTree();
}

class TreeRepository implements ITreeRepository{
  @override
  Future<List<TreeEntity>> getTree()async{
    Response response;
    var dio = Dio();
    try{
      response = await dio.get('https://apitestemobile-production.up.railway.app/tree');
      if(response.statusCode == 200){
        List<dynamic> data = response.data;
        return data.map((json)=> TreeEntity.fromJson(json)).toList();
      }else{
        throw Exception('falha ao carregar os equipamentos');
      }
    }catch (e){
      throw Exception('Erro ao carregar os equipamentos');
    }
  }
}
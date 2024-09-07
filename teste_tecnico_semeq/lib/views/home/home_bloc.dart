import 'dart:async';

import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';
import 'package:teste_tecnico_semeq/repositories/tree_repository.dart';

abstract class IHomeBloc{
  Stream<List<TreeEntity>> get treeStream;
  void fetchTree();
}

class HomeBloc implements IHomeBloc{
  final ITreeRepository _treeRepository;
  final StreamController<List<TreeEntity>> _treeController = StreamController<List<TreeEntity>>.broadcast();

  HomeBloc(this._treeRepository);
  @override
  Stream<List<TreeEntity>> get treeStream => _treeController.stream;

  @override 
  void fetchTree()async{
    try{
      List<TreeEntity> tree = await _treeRepository.getTree();
      _treeController.sink.add(tree);
    }catch (e) {
      _treeController.sink.addError('Falha ao carregar os produtos');
    }
  }
   void dispose() {
    _treeController.close();
  }
}
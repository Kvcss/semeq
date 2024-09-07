import 'dart:async';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';
import 'package:teste_tecnico_semeq/repositories/tree_repository.dart';
import 'package:teste_tecnico_semeq/repositories/tree_sql_data_base.dart';

abstract class IHomeBloc {
  Stream<List<TreeEntity>> get treeStream;
  void fetchTree(var accessToken);
  Future<void> loadOfflineTree(); 
  Future<void> checkAndFetchTree(String accessToken);
}

class HomeBloc implements IHomeBloc {
  final ITreeRepository _treeRepository;
  final StreamController<List<TreeEntity>> _treeController = StreamController<List<TreeEntity>>.broadcast();
  final TreeDatabaseHelper _dbHelper = TreeDatabaseHelper();  

  HomeBloc(this._treeRepository);
  
  @override
  Stream<List<TreeEntity>> get treeStream => _treeController.stream;

  @override
  Future<void> fetchTree(var accessToken) async {
    try {
      List<TreeEntity> tree = await _treeRepository.getTree(accessToken);
      _treeController.sink.add(tree);
      await _dbHelper.clearTreeData();
      await _dbHelper.insertTreeData(tree);
    } catch (e) {
      _treeController.sink.addError('Falha ao carregar os equipamentos');
    }
  }

  @override
  Future<void> loadOfflineTree() async {
    try {
      List<TreeEntity> offlineTree = await _dbHelper.fetchTreeData();
      if (offlineTree.isNotEmpty) {
        _treeController.sink.add(offlineTree);
      } else {
        _treeController.sink.addError('Nenhuma árvore encontrada offline.');
      }
    } catch (e) {
      _treeController.sink.addError('Erro ao carregar a árvore offline');
    }
  }

  @override
  Future<void> checkAndFetchTree(String accessToken) async {
    bool isConnected = await _checkConnectivity();
    if (isConnected) {
      fetchTree(accessToken);  
    } else {
      loadOfflineTree();  
    }
  }

  Future<bool> _checkConnectivity() async {
  //var connectivityResult = await Connectivity().checkConnectivity();
  return true;
}


  void dispose() {
    _treeController.close();
  }
}
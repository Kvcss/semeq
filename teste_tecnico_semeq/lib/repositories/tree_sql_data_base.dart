// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teste_tecnico_semeq/repositories/entities/tree_entity.dart';

class TreeDatabaseHelper {
  static final TreeDatabaseHelper _instance = TreeDatabaseHelper._internal();
  static Database? _database;

  factory TreeDatabaseHelper() {
    return _instance;
  }

  TreeDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'tree_database.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tree (
        id INTEGER PRIMARY KEY,
        name TEXT,
        level INTEGER,
        parent INTEGER
      )
    ''');
  }

  Future<void> insertTreeData(List<TreeEntity> treeData) async {
    final db = await database;

    for (var entity in treeData) {
      await db.insert(
        'tree',
        entity.toJson(), 
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<TreeEntity>> fetchTreeData() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('tree');

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return TreeEntity.fromJson(maps[i]);
      });
    } else {
      return [];
    }
  }

  Future<void> clearTreeData() async {
    final db = await database;
    await db.delete('tree');
  }
}

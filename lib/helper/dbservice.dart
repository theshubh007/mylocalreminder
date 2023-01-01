import 'package:mylocalreminder/helper/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const _databaseName = 'Mylocalreminder.db';
  static const _tasks_table = 'tasks_table';
  static const _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $_tasks_table('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, body TEXT, date STRING, time STRING, repeat STRING'
        ')');
  }

  Future<int> insertTask(Task task) async {
    Database? db = DBHelper._database;
    return await db!.insert(_tasks_table, {
      'title': task.title,
      'body': task.body,
      'date': task.date,
      'time': task.time,
      'repeat': task.repeat,
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = DBHelper._database;
    return await db!.query(_tasks_table);
  }

  Future<List<Task>> getalltaskdetails() async {
    Database? db = DBHelper._database;
    final List<Map<String, dynamic>> maps = await db!.query(_tasks_table);

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        repeat: maps[i]['repeat'],
      );
    });
  }

  Future<int> delete(int id) async {
    Database? db = DBHelper._database;
    return await db!.delete(_tasks_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    Database? db = DBHelper._database;
    return await db!.delete(_tasks_table);
  }

  Future<int> update(int id) async {
    return await _database!.rawUpdate('''
    UPDATE $_tasks_table
    SET isCompleted = ?, color = ?
    WHERE id = ?
    ''', [1, 1, id]);
  }
}

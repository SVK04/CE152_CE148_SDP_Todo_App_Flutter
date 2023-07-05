import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_todolist_sqflite');
    var database =
    await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT not null, description TEXT not null)");

    // Create Table Todos
    await database.execute(
        "CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, category TEXT, todoDate TEXT, isFinished INTEGER)");

    // Insert categories
    await _insertCategories(database);
  }

  _insertCategories(Database database) async {
    // Insert three categories
    await database.execute(
        "INSERT INTO categories(name, description) VALUES('School', 'Projects')");
    await database.execute(
        "INSERT INTO categories(name, description) VALUES('College', 'Assignments')");
    await database.execute(
        "INSERT INTO categories(name, description) VALUES('Personal', 'Diary')");
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:ui_challenge_day_two/Models/Note.dart';
import 'package:ui_challenge_day_two/constants/projectColors.dart';

/**
 * SQLite database provider api 
 */

class DBProvider {
  DBProvider._instance();

  static final DBProvider localDBInstance = DBProvider._instance();

  Database? _database;

  Future<Database> getDataBase() async {
    if (_database != null) {
      return _database!;
    }

    //else
    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, Constants.DBName);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute("CREATE TABLE ${Constants.DBName} ("
          "id INTEGER PRIMARY KEY,"
          "title  TEXT,"
          "description  TEXT,"
          "date  TEXT,"
          "createdAt  TEXT,"
          "updatedAt  TEXT,"
          "backgroundColor  TEXT"
          ")");
    });
  }

  //CRUD operations

  //new note in the local db
  newNote(Note note) async {
    var res =
        await (await getDataBase()).insert(Constants.DBName, note.topMap());
    return res;
  }

  //get note specific
  getNoteById(int id) async {
    var res = await (await getDataBase())
        .query(Constants.DBName, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : Null;
  }

  //get all notes from the locale db
  getNotes() async {
    var res = await (await getDataBase()).query(Constants.DBName);
    List<Note> notes = res.isNotEmpty
        ? res.map((note) => Note.fromMap(note)).toList()
        : <Note>[];

    return notes;
  }

  //update specific note
  updateNote(Note note) async {
    var res = await (await getDataBase()).update(
        Constants.DBName, note.topMap(),
        where: "id = ?", whereArgs: [note.id]);
    return res;
  }

  Future<void> deleteNote(Note note) async {
    var res = await (await getDataBase())
        .delete(Constants.DBName, where: "id = ?", whereArgs: [note.id]);
    return;
  }
}

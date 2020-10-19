import 'dart:async';
import 'package:flutter_app/User_Info.dart';
import 'package:sqflite/sqflite.dart';

/// User Information Database.
abstract class UserDB {

  /// Database object.
  static Database _dbUser;

  /// Current version of the database.
  static int get _version => 2;

  /// Number of rows the database currently has.
  static int amountOfRows;


  /// Initiates the database.
  ///
  /// If [_dbUser] is null, then a Database object is created by getting the
  /// [_path] of the database directory on the user's device and opening a new
  /// database there. When the database has no rows yet, a blank input is added.
  static Future<void> init() async {

    if (_dbUser != null) {
      return; }

    try {
      String _path = await getDatabasesPath() + 'user_db';
      _dbUser = await openDatabase(_path, version: _version, onCreate: onCreate);

      amountOfRows = await getCount();

      if(amountOfRows == 0) {
        addBlankInput();
      }

    }
    catch(ex) {
      print(ex);
    }
  }

  /// Creates a table that stores the data.
  ///
  /// The table currently has the columns id, username, password,
  /// passwordHintQuestion, and passwordHintAnswer.
  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE database (id INTEGER PRIMARY KEY NOT NULL, username TEXT, password TEXT, passwordHintQuestion TEXT, passwordHintAnswer TEXT)');

  /// Returns a list of all the entries in database's [table].
  static Future<List<Map<String, dynamic>>> query(String table) async => _dbUser.query(table);

  /// Inserts the [info] in the database [table].
  static Future<int> insert(String table, UserInfo info) async =>
      await _dbUser.insert(table, info.toMap());

  /// Updates the database [table] in case the [info] is edited.
  static Future<int> update(String table, UserInfo info) async =>
      await _dbUser.update(table, info.toMap(), where: 'id = ?', whereArgs: [info.id]);

  /// Deletes the [info] from the database [table].
  static Future<int> delete(String table, UserInfo info) async =>
      await _dbUser.delete(table, where: 'id = ?', whereArgs: [info.id]);

  /// Returns the user info given its database [id].
  static Future<UserInfo> info(int id) async {
    var res = await  _dbUser.query("database", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? UserInfo.fromMap(res.first) : Null ;
  }

  /// Adds a blank input to the database.
  static Future<void> addBlankInput() async {
    UserInfo userInfo = UserInfo(
          username: "TEST",
          password: "TEST",
          passwordHintQuestion: "TEST",
          passwordHintAnswer: "TEST");
        await _dbUser.insert(UserInfo.table, userInfo.toMap());
  }

  /// Returns the number of entries in the database.
  static Future<int> getCount() async {
    List<Map> list = await _dbUser.rawQuery('SELECT * FROM database');
    int count = list.length;
    return count;
  }
}

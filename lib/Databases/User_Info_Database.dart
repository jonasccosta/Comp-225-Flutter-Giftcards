import 'dart:async';
import 'package:flutter_app/User_Info.dart';
import 'package:sqflite/sqflite.dart';

import '../Gift_Card.dart';

abstract class UserDB {

  static Database _dbUser;

  static int get _version => 2;

  static int amountOfRows;


  //Initiates the database
  static Future<void> init() async {

    if (_dbUser != null) {
      return; }

    try {
      String _path = await getDatabasesPath() + 'user_db';
      _dbUser = await openDatabase(_path, version: _version, onCreate: onCreate);

      amountOfRows = await getCount();
      print('getCount: ' + amountOfRows.toString());

      if(amountOfRows == 0) {
        print('here');
        addBlankInput();
      }

      print('getCount: ' + amountOfRows.toString());
    }
    catch(ex) {
      print(ex);
    }
  }

  //Creates a table that stores the data
  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE database (id INTEGER PRIMARY KEY NOT NULL, username TEXT, password TEXT, passwordHintQuestion TEXT, passwordHintAnswer TEXT)');

  //Returns the table containing the data
  static Future<List<Map<String, dynamic>>> query(String table) async => _dbUser.query(table);

  //Inserts user info in the database
  static Future<int> insert(String table, UserInfo info) async =>
      await _dbUser.insert(table, info.toMap());

  //Update the database in case the user info is edited
  static Future<int> update(String table, UserInfo info) async =>
      await _dbUser.update(table, info.toMap(), where: 'id = ?', whereArgs: [info.id]);

  //Deletes user info from the database
  static Future<int> delete(String table, UserInfo info) async =>
      await _dbUser.delete(table, where: 'id = ?', whereArgs: [info.id]);

  //Returns the user info given its database id
  static Future<UserInfo> info(int id) async {
    var res = await  _dbUser.query("database", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? UserInfo.fromMap(res.first) : Null ;
  }

  static Future<void> addBlankInput() async {
    UserInfo userInfo = UserInfo(
          username: "TEST",
          password: "TEST",
          passwordHintQuestion: "TEST",
          passwordHintAnswer: "TEST");
        await _dbUser.insert(UserInfo.table, userInfo.toMap());
  }

  static Future<int> getCount() async {
    List<Map> list = await _dbUser.rawQuery('SELECT * FROM database');
    int count = list.length;
    return count;
  }
}

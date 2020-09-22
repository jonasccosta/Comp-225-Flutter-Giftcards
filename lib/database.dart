import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'card.dart';

abstract class DB {

  static Database _db;

  static int get _version => 1;


  //Initiates the database
  static Future<void> init() async {

    if (_db != null) { return; }

    try {
      String _path = await getDatabasesPath() + 'db';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    }
    catch(ex) {
      print(ex);
    }
  }

  //Creates a table that stores the data
  static void onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE database (id INTEGER PRIMARY KEY NOT NULL, name STRING)');

  //Returns the table containing the data
  static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

  //Inserts a new card in the database
  static Future<int> insert(String table, Card card) async =>
      await _db.insert(table, card.toMap());

  //Update the database in case a card is edited
  static Future<int> update(String table, Card card) async =>
      await _db.update(table, card.toMap(), where: 'id = ?', whereArgs: [card.id]);

  //Deletes a card from the database
  static Future<int> delete(String table, Card card) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [card.id]);

  //Returns a single card given its database id
  static Future<Card> card(int id) async {
    var res = await  _db.query("database", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Card.fromMap(res.first) : Null ;
  }


}
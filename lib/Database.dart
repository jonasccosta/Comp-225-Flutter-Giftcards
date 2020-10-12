import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'Gift_Card.dart';

/// App database
abstract class DB {

  /// Database object
  static Database _db;

  /// Current version of the database
  static int get _version => 2;

  /// Initiates the database
  ///
  /// If [_db] is null, then a Database object is created by getting the [_path]
  /// of the database directory on the user's device and opening a new database
  /// there.
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

  /// Creates a table that stores the data.
  ///
  /// The table currently has the columns id, name, number, expirationDate,
  /// securityCode, balance, photo.
  static void onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE database (id INTEGER PRIMARY KEY NOT NULL, name TEXT, number TEXT, expirationDate TEXT, securityCode TEXT, balance TEXT, photo TEXT)');
  }

  /// Returns a list of all the entries in database's [table].
  static Future<List<Map<String, dynamic>>> query(String table) async {
    return _db.query(table);
  }

  /// Inserts the [card] in the database [table].
  static Future<int> insert(String table, GiftCard card) async {
    return await _db.insert(table, card.toMap());
  }

  /// Updates the database [table] in case the [card] is edited.
  static Future<int> update(String table, GiftCard card) async {
    return await _db.update(table, card.toMap(), where: 'id = ?', whereArgs: [card.id]);
  }

  /// Deletes the [card] from the database [table].
  static Future<int> delete(String table, GiftCard card) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [card.id]);

}
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:inicioestudotroneio/models/game_model.dart';

class SqlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(""" CREATE TABLE games(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      description TEXT,
      date TEXT,
      platform TEXT,
      company TEXT,
      image TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'games.db',
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createGame(
      String title, String description,String date, String platform, String company, String image) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'date': date,
      'platform': platform,
      'company': company,
      'image': image,
    };

    final id = await db.insert(
      'games',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SqlHelper.db();

    return db.query('games', orderBy: "id");
  }

  static Future<GameModel> getItem(int id) async {
    final db = await SqlHelper.db();

    final maps = await db.query('games', where: "id = ?", whereArgs: [id]);

    if (maps.isEmpty) {
      throw Exception("No game found with id $id");
    }

    return GameModel.fromJson(maps.first);
  }

  static Future<int> updateGame(
      int id,
      String title,
      String description,
      String date,
      String platform,
      String company,
      String image,
      ) async {
    final db = await SqlHelper.db();

    final data = {
      'title': title,
      'description': description,
      'date': date,
      'platform': platform,
      'company': company,
      'image': image,
    };

    final result = await db.update('games', data, where: "id = ?", whereArgs: [id]);

    return result;
  }

  static Future<void> deleteGame(int uuid) async {
    final db = await SqlHelper.db();

    try {
      await db.delete('games', where: "id = ?", whereArgs: [uuid]);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}

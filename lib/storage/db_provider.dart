import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:musiclyric/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/song.dart';

Future<DBProvider> initDBProvider() async {
  DBProvider dbProvider = DBProvider._();
  dbProvider._initDB();
  return dbProvider;
}

class DBProvider {
  DBProvider._();

  Database? _database;

  final _SONG_TABLE = "music";

  Future<Database> get _db async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_asset_db.md
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "english_music.db");

    deleteDatabase(path);

    // Open the database and insert the data
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            logger("onCreate");
            await db.execute('''
                                  CREATE TABLE IF NOT EXISTS "music" (
                                    "id" integer PRIMARY KEY AUTOINCREMENT,
                                    "nameOfSong" text,
                                    "artist" text,
                                    "fileName" text,
                                    "lyric" text,
                                    "duration" text,
                                    "link" text,
                                    "path" text,
                                    "pathFileMacOs" text
                                  );
                                ''');
            // for (var item in dataJson) {
            //   await db.insert(_SONG_TABLE, item);
            // }
          },
        ));

    // return _generateDb(path);

    // Check if the database exists
    // var exists = await databaseExists(path);

    // logger(exists);

    // if (!exists) {
    //   return _generateDb(path);

    //   // Should happen only the first time you launch your application
    //   print("Creating new copy from asset");

    //   // Make sure the parent directory exists
    //   try {
    //     await Directory(dirname(path)).create(recursive: true);
    //   } catch (_) {}

    //   // Copy from asset
    //   ByteData data = await rootBundle.load('assets/english_music.db');
    //   List<int> bytes =
    //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //   if (kIsWeb) {
    //     final jsonString = await rootBundle.loadString('assets/data.json');
    //     final data = json.decode(jsonString) as List<dynamic>;

    //     // Open the database and insert the data
    //     final database = await databaseFactory.openDatabase(path,
    //         options: OpenDatabaseOptions(
    //           version: 1,
    //           onCreate: (db, version) async {
    //             await db.execute('''
    //                               CREATE TABLE IF NOT EXISTS "music" (
    //                                 "id" integer PRIMARY KEY AUTOINCREMENT,
    //                                 "nameOfSong" text,
    //                                 "artist" text,
    //                                 "fileName" text,
    //                                 "lyric" text,
    //                                 "duration" text,
    //                               );
    //                             ''');
    //             for (var item in data) {
    //               await db.insert('music', item);
    //             }
    //           },
    //         ));

    //     return database;
    //   } else {
    //     // Write and flush the bytes written
    //     await File(path).writeAsBytes(bytes, flush: true);
    //   }
    // } else {
    //   logger("Opening existing database");
    // }

    // // open the database
    // return await openDatabase(path);

    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, "english_music.db");
    // return await openDatabase(path, version: 1, onOpen: (db) {},
    //     onCreate: (Database db, int version) async {
    //   // await db.execute("CREATE TABLE Client ("
    //   //     "id INTEGER PRIMARY KEY,"
    //   //     "first_name TEXT,"
    //   //     "last_name TEXT,"
    //   //     "blocked BIT"
    //   //     ")");
    // });
  }

  Future<List<Song>> getAllMusic() async {
    final db = await _db;
    var res = await db.query(_SONG_TABLE);
    List<Song> list =
        res.isNotEmpty ? res.map((c) => Song.fromMap(c)).toList() : [];
    return list;
  }

  Future insertListSong(List<dynamic> items) async {
    final db = await _db;
    for (var item in items) {
      await db.insert('music', item);
    }
  }

  Future update(Song song) async {
    // print(song.link);
    final db = await _db;

    try {
      await db.transaction((txn) async {
        // Perform your database updates here using the transaction object (txn)
        await txn.update(_SONG_TABLE, {Song.LINK: song.link},
            where: 'id = ?', whereArgs: [song.id]);
      });
    } catch (e) {
      logger(e);
    }
  }
}

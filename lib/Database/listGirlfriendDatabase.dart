import 'package:agora_new_updated/models/GirlFriendModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GirlfriendDatabaseHelper {
  static final GirlfriendDatabaseHelper _instance =
      GirlfriendDatabaseHelper._internal();
  factory GirlfriendDatabaseHelper() => _instance;

  static Database? _database;

  GirlfriendDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'girlfriend.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE girlfriend(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userName TEXT,
            userGender TEXT,
            dob TEXT,
            interests TEXT,
            girlFriendImage TEXT,
            girlFriendName TEXT,
            girlFriendGender TEXT,
            girlFriendAge INTEGER,
            girlFriendPersonality TEXT,
            conversationID TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertGirlfriend(GirlFriend data) async {
    final db = await database;
    await db.insert(
      'girlfriend',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GirlFriend>> getAllGirlfriends() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('girlfriend');

    return List.generate(maps.length, (i) {
      return GirlFriend.fromMap(maps[i]);
    });
  }

  // Method to delete a girlfriend by name or id
  Future<int> deleteGirlfriendByName(String conversationID) async {
    Database? db = await database;
    return await db.delete(
      'girlfriend',
      where: 'conversationID = ?',
      whereArgs: [conversationID],
    );
  }

  Future<void> deleteGirlfriend(int id) async {
    final db = await database;
    await db.delete(
      'girlfriend',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateGirlfriend(GirlFriend user, int id) async {
    final db = await database;
    await db.update(
      'girlfriend',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

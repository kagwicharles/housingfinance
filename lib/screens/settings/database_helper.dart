import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'tm_local.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profile_image (
        id INTEGER PRIMARY KEY,
        imageString TEXT
      )
    ''');
  }

  Future<void> insertProfileImage(String imageString) async {
    final db = await database;
    await db.insert('profile_image', {'imageString': imageString});
  }

  Future<String?> getProfileImage() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profile_image');
    if (maps.isNotEmpty) {
      return maps.first['imageString'] as String?;
    }
    return null;
  }

  Future<void> updateImage(String newImageBase64) async {
    final db = await database;

    await db.update(
      'profile_image',
      {'imageString': newImageBase64},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}

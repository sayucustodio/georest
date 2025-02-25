import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('restaurants.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE restaurants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        ruc TEXT,
        latitude REAL,
        longitude REAL,
        comment TEXT,
        synced INTEGER DEFAULT 0
      );
    ''');
    
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        restaurant_id INTEGER,
        photo_type TEXT,
        file_path TEXT,
        timestamp TEXT,
        FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<int> insertRestaurant(Map<String, dynamic> restaurant) async {
    final db = await instance.database;
    return await db.insert('restaurants', restaurant);
  }

  Future<List<Map<String, dynamic>>> getRestaurants() async {
    final db = await instance.database;
    return await db.query('restaurants');
  }
}
*/
import 'package:prueba_1/models/restaurant_model.dart';
import 'package:prueba_1/models/tipo_foto_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();
  static Database? db;

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await init();
    return db!;
  }

  static Future<Database> init() async {
    String path = join(await getDatabasesPath(), 'georest.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE photo_types (
            uuid TEXT PRIMARY KEY,
            name TEXT,
            description TEXT
          )
        ''');
        db.execute('''
          CREATE TABLE restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            ruc TEXT,
            latitude REAL,
            longitude REAL,
            comment TEXT,
            uuid TEXT,
            createdAt TEXT,
            updatedAt TEXT,
            isSynced INTEGER DEFAULT 0 -- 0 = No sincronizado, 1 = Sincronizado
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute("ALTER TABLE restaurants ADD COLUMN ruc TEXT NOT NULL;");
        await db.execute("ALTER TABLE restaurants ADD COLUMN uuid TEXT;");
    await db.execute("ALTER TABLE restaurants ADD COLUMN createdAt TEXT;");
    await db.execute("ALTER TABLE restaurants ADD COLUMN updatedAt TEXT;");
      }
    },
    );
  }

  //Metodos para tipos de fotos
  Future<void> insertPhotoTypes(List<TipoFotoModel> photoTypes) async {
    final db = await database;
    Batch batch = db.batch();
    for (var photoType in photoTypes) {
      batch.insert(
        'photo_types',
        photoType.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getPhotoTypes() async {
    final db = await database;
    return await db.query('photo_types');
  }

  // Métodos para Restaurantes
  Future<void> insertRestaurant(RestaurantModel restaurants) async {
    final db = await database;
    await db.insert(
      'restaurants',
      restaurants.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //sincronizar restaurante
  Future<int> updateRestaurant(RestaurantModel restaurant) async {
    final db = await database;
    return await db.update(
      'restaurants',
      {
        'name':restaurant.name,
        'ruc':restaurant.ruc,
        'latitude' : restaurant.latitude,
            'longitude':restaurant.longitude,
            'comment':restaurant.comment,
        'uuid': restaurant.uuid, // Guardamos el UUID de la API
        'createdAt': restaurant.createdAt,
        'updatedAt': restaurant.updatedAt,
         'isSynced': 1
      },
      where: 'ruc = ?',
      whereArgs: [restaurant.ruc], // Asegúrate de que tu modelo tiene 'id'
    );
  }

  /*Future<void> insertRestaurant(Map<String, dynamic> restaurant) async {
    final db = await database;
    await db.insert('restaurants', restaurant, conflictAlgorithm: ConflictAlgorithm.replace);
  }*/
  /*Future<List<RestaurantModel>> getRestaurants() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('restaurants');

  return maps.map((map) => RestaurantModel.fromMap(map)).toList();
}
 */
  Future<List<Map<String, dynamic>>> getRestaurants() async {
    final db = await database;
    return await db.query('restaurants');
  }
}

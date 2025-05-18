// lib/services/database_service.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static const _dbName = 'app.db';
  static const _dbVersion = 2; // ⬆ bumped from 1 to 2
  static const tripsTable = 'trips';
  static const baggageTable = 'baggage_items';

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // ← new
    );
    return _db!;
  }

  // Called only when creating a brand-new database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tripsTable (
        id TEXT PRIMARY KEY,
        title TEXT,
        origin TEXT,
        destination TEXT,
        start INTEGER,
        end INTEGER,
        hasReturn INTEGER,
        returnTripId TEXT,
        tags TEXT,
        notes TEXT,
        ticketUrl TEXT,
        photoUrl TEXT,
        attachmentPaths TEXT,   -- new column
        pinned INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $baggageTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tripId TEXT,
        name TEXT,
        checked INTEGER,
        position INTEGER
      )
    ''');
  }

  // Called when opening a database with version < _dbVersion
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the new attachmentPaths column
      await db.execute('''
        ALTER TABLE $tripsTable ADD COLUMN attachmentPaths TEXT;
      ''');
    }
    // Future migrations would go here:
    // if (oldVersion < 3) { ... }
  }

  // TRIPS CRUD
  Future<void> insertTrip(Map<String, Object?> row) async {
    final db = await database;
    await db.insert(tripsTable, row);
  }

  Future<List<Map<String, Object?>>> getAllTrips() async {
    final db = await database;
    return db.query(tripsTable);
  }

  Future<void> updateTrip(Map<String, Object?> row) async {
    final db = await database;
    await db.update(tripsTable, row, where: 'id = ?', whereArgs: [row['id']]);
  }

  Future<void> deleteTrip(String id) async {
    final db = await database;
    await db.delete(tripsTable, where: 'id = ?', whereArgs: [id]);
    // cascade-delete baggage_items
    await db.delete(baggageTable, where: 'tripId = ?', whereArgs: [id]);
  }

  // BAGGAGE CRUD
  Future<void> insertBaggage(Map<String, Object?> row) async {
    final db = await database;
    await db.insert(baggageTable, row);
  }

  Future<List<Map<String, Object?>>> getBaggageForTrip(String tripId) async {
    final db = await database;
    return db.query(
      baggageTable,
      where: 'tripId = ?',
      whereArgs: [tripId],
      orderBy: 'position ASC',
    );
  }

  Future<void> updateBaggage(int id, Map<String, Object?> row) async {
    final db = await database;
    await db.update(baggageTable, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteBaggage(int id) async {
    final db = await database;
    await db.delete(baggageTable, where: 'id = ?', whereArgs: [id]);
  }
}

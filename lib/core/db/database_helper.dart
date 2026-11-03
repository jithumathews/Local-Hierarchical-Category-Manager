import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper? _instance;
  static Database? _database;

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'scholigence.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Enable foreign-key constraints
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT    NOT NULL,
        parent_id  INTEGER NULL REFERENCES categories(id) ON DELETE CASCADE,
        created_at TEXT    NOT NULL
      )
    ''');

    // Index on parent_id for fast child lookups
    await db.execute(
      'CREATE INDEX idx_categories_parent_id ON categories(parent_id)',
    );

    // Index on name for search
    await db.execute(
      'CREATE INDEX idx_categories_name ON categories(LOWER(name))',
    );

    // Unique constraint: same name (case-insensitive) under the same parent.
    // COALESCE maps NULL parent to 0 so the unique index covers root nodes too.
    await db.execute('''
      CREATE UNIQUE INDEX idx_categories_unique_name
      ON categories(COALESCE(parent_id, 0), LOWER(name))
    ''');
  }
}


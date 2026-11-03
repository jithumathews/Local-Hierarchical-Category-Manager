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
      version: 2,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        user_id    INTEGER NOT NULL,
        name       TEXT    NOT NULL,
        parent_id  INTEGER NULL REFERENCES categories(id) ON DELETE CASCADE,
        created_at TEXT    NOT NULL
      )
    ''');

    // Index on user_id for multi-tenant scoping
    await db.execute(
      'CREATE INDEX idx_categories_user_id ON categories(user_id)',
    );

    // Index on parent_id for fast child lookups
    await db.execute(
      'CREATE INDEX idx_categories_parent_id ON categories(parent_id)',
    );

    // Index on name for search
    await db.execute(
      'CREATE INDEX idx_categories_name ON categories(LOWER(name))',
    );

    // Unique constraint per user: same name (case-insensitive) under same parent
    await db.execute('''
      CREATE UNIQUE INDEX idx_categories_unique_name
      ON categories(user_id, COALESCE(parent_id, 0), LOWER(name))
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add user_id column with default value 1 for existing categories
      await db.execute(
        'ALTER TABLE categories ADD COLUMN user_id INTEGER NOT NULL DEFAULT 1',
      );
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_categories_user_id ON categories(user_id)',
      );
      // Drop old unique index and recreate per-user
      await db.execute('DROP INDEX IF EXISTS idx_categories_unique_name');
      await db.execute('''
        CREATE UNIQUE INDEX idx_categories_unique_name
        ON categories(user_id, COALESCE(parent_id, 0), LOWER(name))
      ''');
    }
  }
}

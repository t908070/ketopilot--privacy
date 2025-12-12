import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static Database? _database;
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Health Metrics table
    await db.execute('''
      CREATE TABLE health_metrics (
        id TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT NOT NULL,
        notes TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Food Entries table
    await db.execute('''
      CREATE TABLE food_entries (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        serving_size REAL NOT NULL,
        serving_unit TEXT NOT NULL,
        carbs REAL NOT NULL,
        protein REAL NOT NULL,
        fat REAL NOT NULL,
        fiber REAL NOT NULL,
        net_carbs REAL NOT NULL,
        calories REAL NOT NULL,
        notes TEXT,
        brand TEXT,
        meal_type TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // Health Logs table
    await db.execute('''
      CREATE TABLE health_logs (
        id TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL,
        energy_level INTEGER NOT NULL,
        mood_level INTEGER NOT NULL,
        sleep_quality INTEGER NOT NULL,
        mental_clarity INTEGER NOT NULL,
        symptoms TEXT,
        notes TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    // GKI Records table
    await db.execute('''
      CREATE TABLE gki_records (
        id TEXT PRIMARY KEY,
        timestamp INTEGER NOT NULL,
        glucose REAL NOT NULL,
        ketones REAL NOT NULL,
        gki_value REAL NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_health_metrics_timestamp ON health_metrics(timestamp)');
    await db.execute('CREATE INDEX idx_health_metrics_type ON health_metrics(type)');
    await db.execute('CREATE INDEX idx_food_entries_timestamp ON food_entries(timestamp)');
    await db.execute('CREATE INDEX idx_health_logs_timestamp ON health_logs(timestamp)');
    await db.execute('CREATE INDEX idx_gki_records_timestamp ON gki_records(timestamp)');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Add migration logic as needed
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<void> deleteDatabase() async {
    final db = await database;
    await db.close();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}


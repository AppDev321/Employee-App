// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CallHistoryDAO? _callHistoryDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CallHistoryTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userPicUrl` TEXT NOT NULL, `callerName` TEXT NOT NULL, `callType` TEXT NOT NULL, `isIncomingCall` INTEGER NOT NULL, `isMissedCall` INTEGER NOT NULL, `date` TEXT NOT NULL, `callTime` TEXT NOT NULL, `endCallTime` TEXT NOT NULL, `totalCallTime` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CallHistoryDAO get callHistoryDAO {
    return _callHistoryDAOInstance ??=
        _$CallHistoryDAO(database, changeListener);
  }
}

class _$CallHistoryDAO extends CallHistoryDAO {
  _$CallHistoryDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _callHistoryTableInsertionAdapter = InsertionAdapter(
            database,
            'CallHistoryTable',
            (CallHistoryTable item) => <String, Object?>{
                  'id': item.id,
                  'userPicUrl': item.userPicUrl,
                  'callerName': item.callerName,
                  'callType': item.callType,
                  'isIncomingCall': item.isIncomingCall ? 1 : 0,
                  'isMissedCall': item.isMissedCall ? 1 : 0,
                  'date': item.date,
                  'callTime': item.callTime,
                  'endCallTime': item.endCallTime,
                  'totalCallTime': item.totalCallTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CallHistoryTable> _callHistoryTableInsertionAdapter;

  @override
  Future<List<CallHistoryTable>> getAllCallHistory() async {
    return _queryAdapter.queryList('SELECT * FROM CallHistoryTable',
        mapper: (Map<String, Object?> row) => CallHistoryTable(
            row['userPicUrl'] as String,
            row['callerName'] as String,
            row['callType'] as String,
            (row['isIncomingCall'] as int) != 0,
            (row['isMissedCall'] as int) != 0,
            row['date'] as String,
            row['callTime'] as String,
            row['endCallTime'] as String,
            row['totalCallTime'] as String));
  }

  @override
  Future<CallHistoryTable?> getCallHistoryDetail(int id) async {
    return _queryAdapter.query('SELECT * FROM CallHistoryTable WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CallHistoryTable(
            row['userPicUrl'] as String,
            row['callerName'] as String,
            row['callType'] as String,
            (row['isIncomingCall'] as int) != 0,
            (row['isMissedCall'] as int) != 0,
            row['date'] as String,
            row['callTime'] as String,
            row['endCallTime'] as String,
            row['totalCallTime'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteCallHistoryRecord(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM CallHistoryTable WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertCallHistoryRecord(
      CallHistoryTable callHistoryTable) async {
    await _callHistoryTableInsertionAdapter.insert(
        callHistoryTable, OnConflictStrategy.abort);
  }
}

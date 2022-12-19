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

  UserTableDAO? _userTableDAOInstance;

  MessagesTableDAO? _messagesTableDAOInstance;

  ConversationTableDAO? _conversationTableDAOInstance;

  AttachmentsTableDAO? _attachmentTableDAOInstance;

  DownloadTableDAO? _downloadTableDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `CallHistoryTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `callerID` TEXT NOT NULL, `userPicUrl` TEXT NOT NULL, `callerName` TEXT NOT NULL, `callType` TEXT NOT NULL, `isIncomingCall` INTEGER NOT NULL, `isMissedCall` INTEGER NOT NULL, `date` TEXT NOT NULL, `callTime` TEXT NOT NULL, `endCallTime` TEXT NOT NULL, `totalCallTime` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `UserTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `userID` INTEGER, `fullName` TEXT, `email` TEXT, `picture` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MessagesTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `conversationID` INTEGER, `senderID` INTEGER, `receiverID` INTEGER, `content` TEXT, `date` TEXT, `time` TEXT, `isMine` INTEGER, `isAttachments` INTEGER, `deliveryStatus` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ConversationTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `lastMessageID` INTEGER, `senderID` INTEGER, `receiverID` INTEGER, `time` TEXT, `date` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AttachmentsTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `messageID` INTEGER, `attachmentUrl` TEXT, `thumbnailUrl` TEXT, `attachmentType` TEXT, `downloadID` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DownloadStatusTable` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `type` TEXT, `percentage` REAL, `isCompleted` INTEGER, `fileSize` REAL)');

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

  @override
  UserTableDAO get userTableDAO {
    return _userTableDAOInstance ??= _$UserTableDAO(database, changeListener);
  }

  @override
  MessagesTableDAO get messagesTableDAO {
    return _messagesTableDAOInstance ??=
        _$MessagesTableDAO(database, changeListener);
  }

  @override
  ConversationTableDAO get conversationTableDAO {
    return _conversationTableDAOInstance ??=
        _$ConversationTableDAO(database, changeListener);
  }

  @override
  AttachmentsTableDAO get attachmentTableDAO {
    return _attachmentTableDAOInstance ??=
        _$AttachmentsTableDAO(database, changeListener);
  }

  @override
  DownloadTableDAO get downloadTableDAO {
    return _downloadTableDAOInstance ??=
        _$DownloadTableDAO(database, changeListener);
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
                  'callerID': item.callerID,
                  'userPicUrl': item.userPicUrl,
                  'callerName': item.callerName,
                  'callType': item.callType,
                  'isIncomingCall': item.isIncomingCall ? 1 : 0,
                  'isMissedCall': item.isMissedCall ? 1 : 0,
                  'date': item.date,
                  'callTime': item.callTime,
                  'endCallTime': item.endCallTime,
                  'totalCallTime': item.totalCallTime
                }),
        _callHistoryTableUpdateAdapter = UpdateAdapter(
            database,
            'CallHistoryTable',
            ['id'],
            (CallHistoryTable item) => <String, Object?>{
                  'id': item.id,
                  'callerID': item.callerID,
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

  final UpdateAdapter<CallHistoryTable> _callHistoryTableUpdateAdapter;

  @override
  Future<List<CallHistoryTable>> getAllCallHistory() async {
    return _queryAdapter.queryList('SELECT * FROM CallHistoryTable',
        mapper: (Map<String, Object?> row) => CallHistoryTable(
            row['callerID'] as String,
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
  Future<CallHistoryTable?> getLastSingleCallHistoryRecord(String id) async {
    return _queryAdapter.query(
        'SELECT * FROM CallHistoryTable WHERE callerID = ?1 order by id desc limit 1',
        mapper: (Map<String, Object?> row) => CallHistoryTable(row['callerID'] as String, row['userPicUrl'] as String, row['callerName'] as String, row['callType'] as String, (row['isIncomingCall'] as int) != 0, (row['isMissedCall'] as int) != 0, row['date'] as String, row['callTime'] as String, row['endCallTime'] as String, row['totalCallTime'] as String),
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

  @override
  Future<void> updateCallHistoryRecord(
      CallHistoryTable callHistoryTable) async {
    await _callHistoryTableUpdateAdapter.update(
        callHistoryTable, OnConflictStrategy.abort);
  }
}

class _$UserTableDAO extends UserTableDAO {
  _$UserTableDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userTableInsertionAdapter = InsertionAdapter(
            database,
            'UserTable',
            (UserTable item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'fullName': item.fullName,
                  'email': item.email,
                  'picture': item.picture
                }),
        _userTableUpdateAdapter = UpdateAdapter(
            database,
            'UserTable',
            ['id'],
            (UserTable item) => <String, Object?>{
                  'id': item.id,
                  'userID': item.userID,
                  'fullName': item.fullName,
                  'email': item.email,
                  'picture': item.picture
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserTable> _userTableInsertionAdapter;

  final UpdateAdapter<UserTable> _userTableUpdateAdapter;

  @override
  Future<List<UserTable>> getAllUser() async {
    return _queryAdapter.queryList('SELECT * FROM UserTable',
        mapper: (Map<String, Object?> row) => UserTable(
            id: row['id'] as int?,
            userID: row['userID'] as int?,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            picture: row['picture'] as String?));
  }

  @override
  Future<UserTable?> getUserRecord(String id) async {
    return _queryAdapter.query('SELECT * FROM UserTable WHERE userID = ?1',
        mapper: (Map<String, Object?> row) => UserTable(
            id: row['id'] as int?,
            userID: row['userID'] as int?,
            fullName: row['fullName'] as String?,
            email: row['email'] as String?,
            picture: row['picture'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteUserRecord(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM UserTable WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllUser() async {
    await _queryAdapter.queryNoReturn('DELETE FROM UserTable where id>0');
  }

  @override
  Future<void> insertUserRecord(UserTable userTable) async {
    await _userTableInsertionAdapter.insert(
        userTable, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUserRecord(UserTable userTable) async {
    await _userTableUpdateAdapter.update(userTable, OnConflictStrategy.abort);
  }
}

class _$MessagesTableDAO extends MessagesTableDAO {
  _$MessagesTableDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _messagesTableInsertionAdapter = InsertionAdapter(
            database,
            'MessagesTable',
            (MessagesTable item) => <String, Object?>{
                  'id': item.id,
                  'conversationID': item.conversationID,
                  'senderID': item.senderID,
                  'receiverID': item.receiverID,
                  'content': item.content,
                  'date': item.date,
                  'time': item.time,
                  'isMine': item.isMine == null ? null : (item.isMine! ? 1 : 0),
                  'isAttachments': item.isAttachments == null
                      ? null
                      : (item.isAttachments! ? 1 : 0),
                  'deliveryStatus': item.deliveryStatus == null
                      ? null
                      : (item.deliveryStatus! ? 1 : 0)
                }),
        _messagesTableUpdateAdapter = UpdateAdapter(
            database,
            'MessagesTable',
            ['id'],
            (MessagesTable item) => <String, Object?>{
                  'id': item.id,
                  'conversationID': item.conversationID,
                  'senderID': item.senderID,
                  'receiverID': item.receiverID,
                  'content': item.content,
                  'date': item.date,
                  'time': item.time,
                  'isMine': item.isMine == null ? null : (item.isMine! ? 1 : 0),
                  'isAttachments': item.isAttachments == null
                      ? null
                      : (item.isAttachments! ? 1 : 0),
                  'deliveryStatus': item.deliveryStatus == null
                      ? null
                      : (item.deliveryStatus! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MessagesTable> _messagesTableInsertionAdapter;

  final UpdateAdapter<MessagesTable> _messagesTableUpdateAdapter;

  @override
  Future<List<MessagesTable>> getAllMessages(int conversationID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM MessagesTable where conversationID =?1',
        mapper: (Map<String, Object?> row) => MessagesTable(
            id: row['id'] as int?,
            conversationID: row['conversationID'] as int?,
            senderID: row['senderID'] as int?,
            receiverID: row['receiverID'] as int?,
            content: row['content'] as String?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            isMine: row['isMine'] == null ? null : (row['isMine'] as int) != 0,
            isAttachments: row['isAttachments'] == null
                ? null
                : (row['isAttachments'] as int) != 0,
            deliveryStatus: row['deliveryStatus'] == null
                ? null
                : (row['deliveryStatus'] as int) != 0),
        arguments: [conversationID]);
  }

  @override
  Future<MessagesTable?> getMessagesRecord(String id) async {
    return _queryAdapter.query('SELECT * FROM MessagesTable WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MessagesTable(
            id: row['id'] as int?,
            conversationID: row['conversationID'] as int?,
            senderID: row['senderID'] as int?,
            receiverID: row['receiverID'] as int?,
            content: row['content'] as String?,
            date: row['date'] as String?,
            time: row['time'] as String?,
            isMine: row['isMine'] == null ? null : (row['isMine'] as int) != 0,
            isAttachments: row['isAttachments'] == null
                ? null
                : (row['isAttachments'] as int) != 0,
            deliveryStatus: row['deliveryStatus'] == null
                ? null
                : (row['deliveryStatus'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<MessagesTable?> getLastMessageRecordByReceiverID(
      int targetUserID) async {
    return _queryAdapter.query(
        'SELECT * FROM MessagesTable WHERE receiverID = ?1 order by 1 desc limit 1',
        mapper: (Map<String, Object?> row) => MessagesTable(id: row['id'] as int?, conversationID: row['conversationID'] as int?, senderID: row['senderID'] as int?, receiverID: row['receiverID'] as int?, content: row['content'] as String?, date: row['date'] as String?, time: row['time'] as String?, isMine: row['isMine'] == null ? null : (row['isMine'] as int) != 0, isAttachments: row['isAttachments'] == null ? null : (row['isAttachments'] as int) != 0, deliveryStatus: row['deliveryStatus'] == null ? null : (row['deliveryStatus'] as int) != 0),
        arguments: [targetUserID]);
  }

  @override
  Future<void> deleteMessagesRecord(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM MessagesTable WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllMessages() async {
    await _queryAdapter.queryNoReturn('DELETE FROM MessagesTable where id>0');
  }

  @override
  Future<void> insertMessagesRecord(MessagesTable messagesTable) async {
    await _messagesTableInsertionAdapter.insert(
        messagesTable, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateMessagesRecord(MessagesTable messagesTable) async {
    await _messagesTableUpdateAdapter.update(
        messagesTable, OnConflictStrategy.abort);
  }
}

class _$ConversationTableDAO extends ConversationTableDAO {
  _$ConversationTableDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _conversationTableInsertionAdapter = InsertionAdapter(
            database,
            'ConversationTable',
            (ConversationTable item) => <String, Object?>{
                  'id': item.id,
                  'lastMessageID': item.lastMessageID,
                  'senderID': item.senderID,
                  'receiverID': item.receiverID,
                  'time': item.time,
                  'date': item.date
                }),
        _conversationTableUpdateAdapter = UpdateAdapter(
            database,
            'ConversationTable',
            ['id'],
            (ConversationTable item) => <String, Object?>{
                  'id': item.id,
                  'lastMessageID': item.lastMessageID,
                  'senderID': item.senderID,
                  'receiverID': item.receiverID,
                  'time': item.time,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ConversationTable> _conversationTableInsertionAdapter;

  final UpdateAdapter<ConversationTable> _conversationTableUpdateAdapter;

  @override
  Future<List<ConversationTable>> getAllConversation() async {
    return _queryAdapter.queryList('SELECT * FROM ConversationTable',
        mapper: (Map<String, Object?> row) => ConversationTable(
            id: row['id'] as int?,
            lastMessageID: row['lastMessageID'] as int?,
            senderID: row['senderID'] as int?,
            receiverID: row['receiverID'] as int?,
            time: row['time'] as String?,
            date: row['date'] as String?));
  }

  @override
  Future<ConversationTable?> getConversationRecord(String id) async {
    return _queryAdapter.query('SELECT * FROM ConversationTable WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ConversationTable(
            id: row['id'] as int?,
            lastMessageID: row['lastMessageID'] as int?,
            senderID: row['senderID'] as int?,
            receiverID: row['receiverID'] as int?,
            time: row['time'] as String?,
            date: row['date'] as String?),
        arguments: [id]);
  }

  @override
  Future<ConversationTable?> getReceiverRecord(int receiverID) async {
    return _queryAdapter.query(
        'SELECT * FROM ConversationTable WHERE receiverID = ?1 limit 1',
        mapper: (Map<String, Object?> row) => ConversationTable(
            id: row['id'] as int?,
            lastMessageID: row['lastMessageID'] as int?,
            senderID: row['senderID'] as int?,
            receiverID: row['receiverID'] as int?,
            time: row['time'] as String?,
            date: row['date'] as String?),
        arguments: [receiverID]);
  }

  @override
  Future<void> deleteConversationRecord(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM ConversationTable WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllConversation() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM ConversationTable where id>0');
  }

  @override
  Future<void> insertConversationRecord(
      ConversationTable conversationTable) async {
    await _conversationTableInsertionAdapter.insert(
        conversationTable, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateConversationRecord(
      ConversationTable conversationTable) async {
    await _conversationTableUpdateAdapter.update(
        conversationTable, OnConflictStrategy.abort);
  }
}

class _$AttachmentsTableDAO extends AttachmentsTableDAO {
  _$AttachmentsTableDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _attachmentsTableInsertionAdapter = InsertionAdapter(
            database,
            'AttachmentsTable',
            (AttachmentsTable item) => <String, Object?>{
                  'id': item.id,
                  'messageID': item.messageID,
                  'attachmentUrl': item.attachmentUrl,
                  'thumbnailUrl': item.thumbnailUrl,
                  'attachmentType': item.attachmentType,
                  'downloadID': item.downloadID
                }),
        _attachmentsTableUpdateAdapter = UpdateAdapter(
            database,
            'AttachmentsTable',
            ['id'],
            (AttachmentsTable item) => <String, Object?>{
                  'id': item.id,
                  'messageID': item.messageID,
                  'attachmentUrl': item.attachmentUrl,
                  'thumbnailUrl': item.thumbnailUrl,
                  'attachmentType': item.attachmentType,
                  'downloadID': item.downloadID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AttachmentsTable> _attachmentsTableInsertionAdapter;

  final UpdateAdapter<AttachmentsTable> _attachmentsTableUpdateAdapter;

  @override
  Future<List<AttachmentsTable>> getAllAttachments() async {
    return _queryAdapter.queryList('SELECT * FROM AttachmentsTable',
        mapper: (Map<String, Object?> row) => AttachmentsTable(
            id: row['id'] as int?,
            messageID: row['messageID'] as int?,
            attachmentUrl: row['attachmentUrl'] as String?,
            thumbnailUrl: row['thumbnailUrl'] as String?,
            attachmentType: row['attachmentType'] as String?,
            downloadID: row['downloadID'] as int?));
  }

  @override
  Future<AttachmentsTable?> getAttachmentsRecord(String id) async {
    return _queryAdapter.query('SELECT * FROM AttachmentsTable WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AttachmentsTable(
            id: row['id'] as int?,
            messageID: row['messageID'] as int?,
            attachmentUrl: row['attachmentUrl'] as String?,
            thumbnailUrl: row['thumbnailUrl'] as String?,
            attachmentType: row['attachmentType'] as String?,
            downloadID: row['downloadID'] as int?),
        arguments: [id]);
  }

  @override
  Future<AttachmentsTable?> getAttachmentByMsgId(int messageID) async {
    return _queryAdapter.query(
        'SELECT * FROM AttachmentsTable WHERE messageID = ?1',
        mapper: (Map<String, Object?> row) => AttachmentsTable(
            id: row['id'] as int?,
            messageID: row['messageID'] as int?,
            attachmentUrl: row['attachmentUrl'] as String?,
            thumbnailUrl: row['thumbnailUrl'] as String?,
            attachmentType: row['attachmentType'] as String?,
            downloadID: row['downloadID'] as int?),
        arguments: [messageID]);
  }

  @override
  Future<void> deleteAttachmentsRecord(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM AttachmentsTable WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllAttachments() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM AttachmentsTable where id>0');
  }

  @override
  Future<void> insertAttachmentsRecord(
      AttachmentsTable attachmentsTable) async {
    await _attachmentsTableInsertionAdapter.insert(
        attachmentsTable, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateAttachmentsRecord(
      AttachmentsTable attachmentsTable) async {
    await _attachmentsTableUpdateAdapter.update(
        attachmentsTable, OnConflictStrategy.abort);
  }
}

class _$DownloadTableDAO extends DownloadTableDAO {
  _$DownloadTableDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _downloadStatusTableInsertionAdapter = InsertionAdapter(
            database,
            'DownloadStatusTable',
            (DownloadStatusTable item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'percentage': item.percentage,
                  'isCompleted': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'fileSize': item.fileSize
                }),
        _downloadStatusTableUpdateAdapter = UpdateAdapter(
            database,
            'DownloadStatusTable',
            ['id'],
            (DownloadStatusTable item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'percentage': item.percentage,
                  'isCompleted': item.isCompleted == null
                      ? null
                      : (item.isCompleted! ? 1 : 0),
                  'fileSize': item.fileSize
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DownloadStatusTable>
      _downloadStatusTableInsertionAdapter;

  final UpdateAdapter<DownloadStatusTable> _downloadStatusTableUpdateAdapter;

  @override
  Future<List<DownloadStatusTable>> getAllDonwloads() async {
    return _queryAdapter.queryList('SELECT * FROM DownloadStatusTable',
        mapper: (Map<String, Object?> row) => DownloadStatusTable(
            id: row['id'] as int?,
            type: row['type'] as String?,
            percentage: row['percentage'] as double?,
            isCompleted: row['isCompleted'] == null
                ? null
                : (row['isCompleted'] as int) != 0,
            fileSize: row['fileSize'] as double?));
  }

  @override
  Future<DownloadStatusTable?> getDownloadRecord(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM DownloadStatusTable WHERE id = ?1',
        mapper: (Map<String, Object?> row) => DownloadStatusTable(
            id: row['id'] as int?,
            type: row['type'] as String?,
            percentage: row['percentage'] as double?,
            isCompleted: row['isCompleted'] == null
                ? null
                : (row['isCompleted'] as int) != 0,
            fileSize: row['fileSize'] as double?),
        arguments: [id]);
  }

  @override
  Future<void> deleteDownloadRecord(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM DownloadStatusTable WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAllDownloads() async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM DownloadStatusTable where id>0');
  }

  @override
  Future<void> insertDownloadRecord(
      DownloadStatusTable downloadStatusTable) async {
    await _downloadStatusTableInsertionAdapter.insert(
        downloadStatusTable, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateDownloadRecord(
      DownloadStatusTable downloadStatusTable) async {
    await _downloadStatusTableUpdateAdapter.update(
        downloadStatusTable, OnConflictStrategy.abort);
  }
}

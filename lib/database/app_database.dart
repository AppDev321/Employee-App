import 'dart:async';

import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/dao/call_history_dao.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/user_dao.dart';
import 'model/user_table.dart';
import 'model/attachments_table.dart';
import 'model/messages_table.dart';
import 'model/conversation_table.dart';
import 'dao/messages_dao.dart';
import 'dao/conversation_dao.dart';
import 'dao/attachments_dao.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CallHistoryTable,UserTable,MessagesTable,ConversationTable,AttachmentsTable])
abstract class AppDatabase extends FloorDatabase {
  CallHistoryDAO get callHistoryDAO;
  UserTableDAO get userTableDAO;
  MessagesTableDAO get messagesTableDAO;
  ConversationTableDAO get conversationTableDAO;
  AttachmentsTableDAO get attachmentTableDAO;
}
import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/dao/call_history_dao.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [CallHistoryTable])
abstract class AppDatabase extends FloorDatabase {
  CallHistoryDAO get callHistoryDAO;
}



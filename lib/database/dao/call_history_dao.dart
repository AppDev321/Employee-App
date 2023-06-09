import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';

@dao
abstract class CallHistoryDAO {
  @Query('SELECT * FROM CallHistoryTable')
  Future<List<CallHistoryTable>> getAllCallHistory();

  @Query('SELECT * FROM CallHistoryTable WHERE callerID = :id order by id desc limit 1')
  Future<CallHistoryTable?> getLastSingleCallHistoryRecord(String id);

  @Query('DELETE FROM CallHistoryTable WHERE id = :id')
  Future<void> deleteCallHistoryRecord(int id);

  @insert
  Future<void> insertCallHistoryRecord(CallHistoryTable callHistoryTable);

  @update
  Future<void> updateCallHistoryRecord(CallHistoryTable callHistoryTable);
}
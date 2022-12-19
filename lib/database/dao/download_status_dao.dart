import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';

import '../model/attachment_file_status_table.dart';
import '../model/user_table.dart';

@dao
abstract class DownloadTableDAO {
  @Query('SELECT * FROM DownloadStatusTable')
  Future<List<DownloadStatusTable>> getAllDonwloads();
  @Query('SELECT * FROM DownloadStatusTable WHERE id = :id')
  Future<DownloadStatusTable?> getDownloadRecord(int id);
  @Query('DELETE FROM DownloadStatusTable WHERE id = :id')
  Future<void> deleteDownloadRecord(int id);

  @Query('DELETE FROM DownloadStatusTable where id>0')
  Future<void> deleteAllDownloads();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDownloadRecord(DownloadStatusTable downloadStatusTable);

  @update
  Future<void> updateDownloadRecord(DownloadStatusTable downloadStatusTable);
}
import 'package:floor/floor.dart';

import '../model/attachment_file_status_table.dart';

@dao
abstract class DownloadTableDAO {
  @Query('SELECT * FROM DownloadStatusTable')
  Future<List<DownloadStatusTable>> getAllDonwloads();
  @Query('SELECT * FROM DownloadStatusTable WHERE attachmentId = :attachmentId')
  Future<DownloadStatusTable?> getDownloadRecord(int attachmentId);
  @Query('DELETE FROM DownloadStatusTable WHERE id = :id')
  Future<void> deleteDownloadRecord(int id);

  @Query('DELETE FROM DownloadStatusTable where id>0')
  Future<void> deleteAllDownloads();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertDownloadRecord(DownloadStatusTable downloadStatusTable);

  @update
  Future<void> updateDownloadRecord(DownloadStatusTable downloadStatusTable);
}
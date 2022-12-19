import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';

import '../model/user_table.dart';

@dao
abstract class AttachmentsTableDAO {
  @Query('SELECT * FROM AttachmentsTable')
  Future<List<AttachmentsTable>> getAllAttachments();
  @Query('SELECT * FROM AttachmentsTable WHERE id = :id')
  Future<AttachmentsTable?> getAttachmentsRecord(String id);

  @Query('SELECT * FROM AttachmentsTable WHERE messageID = :messageID')
  Future<AttachmentsTable?> getAttachmentByMsgId(int messageID);

  @Query('DELETE FROM AttachmentsTable WHERE id = :id')
  Future<void> deleteAttachmentsRecord(int id);

  @Query('DELETE FROM AttachmentsTable where id>0')
  Future<void> deleteAllAttachments();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachmentsRecord(AttachmentsTable attachmentsTable);

  @update
  Future<void> updateAttachmentsRecord(AttachmentsTable attachmentsTable);
}
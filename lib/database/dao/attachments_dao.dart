import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';

@dao
abstract class AttachmentsTableDAO {
  @Query('SELECT * FROM AttachmentsTable')
  Future<List<AttachmentsTable>> getAllAttachments();
  @Query('SELECT * FROM AttachmentsTable WHERE id = :id')
  Future<AttachmentsTable?> getAttachmentsRecord(int id);

  @Query('SELECT * FROM AttachmentsTable WHERE messageID = :messageID order by id desc limit 1')
  Future<AttachmentsTable?> getAttachmentByMsgId(int messageID);

  @Query('DELETE FROM AttachmentsTable WHERE id = :id')
  Future<void> deleteAttachmentsRecord(int id);

  @Query('DELETE FROM AttachmentsTable where id>0')
  Future<void> deleteAllAttachments();


  @Query('DELETE FROM AttachmentsTable WHERE conversationID = :conversationID')
  Future<AttachmentsTable?> deleteConversationAttachment(int conversationID);


  @Query('DELETE FROM AttachmentsTable WHERE messageID = :messageID')
  Future<AttachmentsTable?> deleteMessageAttachment(int messageID);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAttachmentsRecord(AttachmentsTable attachmentsTable);

  @update
  Future<void> updateAttachmentsRecord(AttachmentsTable attachmentsTable);
}
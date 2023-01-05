import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:hnh_flutter/database/model/messages_table.dart';

import '../model/user_table.dart';

@dao
abstract class MessagesTableDAO {
  @Query('SELECT * FROM MessagesTable where conversationID =:conversationID')
  Future<List<MessagesTable>> getAllMessages(int conversationID);
  @Query('SELECT * FROM MessagesTable WHERE id = :id')
  Future<MessagesTable?> getMessagesRecord(String id);


  @Query('SELECT * FROM MessagesTable WHERE receiverID = :targetUserID order by 1 desc limit 1')
  Future<MessagesTable?> getLastMessageRecordByReceiverID(int targetUserID);


  @Query('DELETE FROM MessagesTable WHERE conversationID = :conversationID')
  Future<void> deleteAllConversationMessage(int conversationID);


  @Query('DELETE FROM MessagesTable WHERE id = :id')
  Future<void> deleteMessagesRecord(int id);

  @Query('DELETE FROM MessagesTable where id>0')
  Future<void> deleteAllMessages();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMessagesRecord(MessagesTable messagesTable);

  @update
  Future<void> updateMessagesRecord(MessagesTable messagesTable);
}
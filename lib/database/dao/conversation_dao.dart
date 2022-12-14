import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';

import '../model/user_table.dart';

@dao
abstract class ConversationTableDAO {
  @Query('SELECT * FROM ConversationTable')//orderbydecendent
  Future<List<ConversationTable>> getAllConversation();
  @Query('SELECT * FROM ConversationTable WHERE id = :id')
  Future<ConversationTable?> getConversationRecord(String id);


  @Query('SELECT * FROM ConversationTable WHERE receiverID = :receiverID limit 1')
  Future<ConversationTable?> getReceiverRecord(int receiverID);


  @Query('DELETE FROM ConversationTable WHERE id = :id')
  Future<void> deleteConversationRecord(int id);

  @Query('DELETE FROM ConversationTable where id>0')
  Future<void> deleteAllConversation();

  @insert
  Future<void> insertConversationRecord(ConversationTable conversationTable);

  @update
  Future<void> updateConversationRecord(ConversationTable conversationTable);
}
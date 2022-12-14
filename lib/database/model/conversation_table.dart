import 'package:floor/floor.dart';

@entity
class ConversationTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? lastMessageID;
  int? senderID;
  int? receiverID;
  String? time;
  String? date;

  ConversationTable({this.id,this.lastMessageID, this.senderID,this.receiverID,this.time,this.date});
}
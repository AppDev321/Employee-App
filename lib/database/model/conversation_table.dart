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
  bool? isNewMessage;

  ConversationTable({this.id,this.lastMessageID, this.senderID,this.receiverID,this.time,this.date,this.isNewMessage});



  ConversationTable.fromJson(Map<String,dynamic> json) {
    //id = json["id"];
    senderID = json["senderID"];
    receiverID = json["receiverID"];
    lastMessageID = json["lastMessageID"];
    date = json["date"];
    time = json["time"];
    isNewMessage = json['isNewMessage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data["id"] = this.id;
    data["senderID"] = this.senderID;
    data["receiverID"] = this.receiverID;
    data["lastMessageID"] = this.lastMessageID;
    data["date"] = this.date;
    data["time"] = this.time;
    data['isNewMessage'] = this.isNewMessage;
    return data;
  }
}
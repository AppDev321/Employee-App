import "package:floor/floor.dart";

@entity
class MessagesTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? conversationID;
  int? senderID;
  int? receiverID;
  String? content;
  String? date;
  String? time;
  bool? isMine;
  bool? isAttachments;
  bool? deliveryStatus;

  MessagesTable({this.id,this.conversationID, this.senderID, this.receiverID,
    this.content,this.date,this.time,this.isMine,this.isAttachments,this.deliveryStatus});

  MessagesTable.fromJson(Map<String,dynamic> json) {

    //id = json["id"];

    conversationID = json["conversationID"];
    senderID = json["senderID"];
    receiverID = json["receiverID"];
    content = json["content"];
    date = json["date"];
    time = json["time"];
    isMine = json["isMine"];
    isAttachments = json["isAttachments"];
    deliveryStatus = json["deliveryStatus"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   // data["id"] = this.id;
    data["conversationID"] = this.conversationID;
    data["senderID"] = this.senderID;
    data["receiverID"] = this.receiverID;
    data["content"] = this.content;
    data["date"] = this.date;
    data["time"] = this.time;
    data["isMine"] = this.isMine;
    data["isAttachments"] = this.isAttachments;
    data["deliveryStatus"] = this.deliveryStatus;
    return data;
  }
}
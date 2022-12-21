import 'package:floor/floor.dart';

@entity
class AttachmentsTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? messageID;
  String? attachmentUrl;
  String? thumbnailUrl;
  String? attachmentType;
  int? downloadID;
  String? serverFileUrl;

  AttachmentsTable({this.id,this.messageID, this.attachmentUrl,this.thumbnailUrl,this.attachmentType,this.downloadID,this.serverFileUrl});



  AttachmentsTable.fromJson(Map<String,dynamic> json) {
    //id = json["id"];
    messageID = json["messageID"];
    attachmentUrl = json["attachmentUrl"];
    thumbnailUrl = json["thumbnailUrl"];
    attachmentType = json["attachmentType"];
    downloadID = json["downloadID"];
    serverFileUrl = json["serverFileUrl"];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    // data["id"] = this.id;
    data["messageID"] = this.messageID;
    data["attachmentUrl"] = this.attachmentUrl;
    data["thumbnailUrl"] = this.thumbnailUrl;
    data["attachmentType"] = this.attachmentType;
    data["downloadID"] = this.downloadID;
    data["serverFileUrl"] = this.serverFileUrl;
    return data;
  }

}
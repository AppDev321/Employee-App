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

  AttachmentsTable({this.id,this.messageID, this.attachmentUrl,this.thumbnailUrl,this.attachmentType,this.downloadID });
}
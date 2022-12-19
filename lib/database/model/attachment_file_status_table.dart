import 'package:floor/floor.dart';

@entity
class DownloadStatusTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String? type; //upload,download
  double? percentage;
  bool? isCompleted; //status of upload and download
  double? fileSize;


  DownloadStatusTable({this.id,this.type, this.percentage,this.isCompleted,this.fileSize });
}
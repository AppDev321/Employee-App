import 'package:floor/floor.dart';

@entity
class UserTable {
  @PrimaryKey(autoGenerate: true)
  int? id;
  int? userID;
  String? fullName;
  String? email;
  String? picture;

  UserTable({this.id,this.userID, this.fullName, this.email, this.picture});
}
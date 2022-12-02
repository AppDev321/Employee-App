import 'package:floor/floor.dart';
import 'package:hnh_flutter/database/model/call_history_table.dart';

import '../model/user_table.dart';

@dao
abstract class UserTableDAO {
  @Query('SELECT * FROM UserTable')
  Future<List<UserTable>> getAllUser();
  @Query('SELECT * FROM UserTable WHERE id = :id')
  Future<UserTable?> getUserRecord(String id);
  @Query('DELETE FROM UserTable WHERE id = :id')
  Future<void> deleteUserRecord(int id);

  @Query('DELETE FROM UserTable where id>0')
  Future<void> deleteAllUser();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUserRecord(UserTable userTable);

  @update
  Future<void> updateUserRecord(UserTable userTable);
}
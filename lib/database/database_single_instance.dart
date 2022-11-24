import 'app_database.dart';

class AFJDatabaseInstance {
  static final AFJDatabaseInstance _singleton = AFJDatabaseInstance._();
  static AFJDatabaseInstance get instance => _singleton;
  AFJDatabaseInstance._();
  AppDatabase? db;
  Future<AppDatabase?> get afjDatabase async {
     db ??= await $FloorAppDatabase
          .databaseBuilder('afj_database.db')
          .build();
    return db;
  }


  // Future<AppDatabase?> get _db async => await AFJDatabaseInstance.instance.afjDatabase;

}
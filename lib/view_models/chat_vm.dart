import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';

import '../database/dao/call_history_dao.dart';
import '../database/database_single_instance.dart';
import '../database/model/call_history_table.dart';
import '../repository/model/response/contact_list.dart';

class ChatViewModel extends BaseViewModel {
  List<User> listUser = [];

/*


  Future<void> getContactList() async {
    setLoading(true);
 final results=await APIWebService().getContactList();
    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);

   setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        listUser = results.data!.contacts!;



      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += "${results.errors![i].message!}\n";
        }
        setErrorMsg(errorString);

     setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }
*/

  Future<List<User>> getContactList() async {
    final results = await APIWebService().getContactList();
    final listData = results?.data?.contacts as List<User>;
    return listData;
  }

  Future<List<CallHistoryTable>> getCallHistoryList() async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final callHistoryDao = db?.callHistoryDAO as CallHistoryDAO;
    return await callHistoryDao.getAllCallHistory();
  }
}

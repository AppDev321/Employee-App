import 'dart:async';

import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../database/dao/call_history_dao.dart';
import '../database/database_single_instance.dart';

import '../database/model/call_history_table.dart';
import '../repository/model/request/socket_message_model.dart';
import '../repository/model/response/contact_list.dart';
import '../utils/controller.dart';

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


  void insertCallDetailInDB(SocketMessageModel socketMessageModel) async
  {

    var now =  DateTime.now();
    final db =  await AFJDatabaseInstance.instance.afjDatabase;
    final callHistoryDAO = db?.callHistoryDAO as CallHistoryDAO;
    var data =
    CallHistoryTable(
        socketMessageModel.sendFrom.toString(),
        "",
        socketMessageModel.callerName.toString(),
        socketMessageModel.callType.toString(),
        false,
        false,
        Controller().getConvertedDate(now),
        Controller().getConvertedTime(now),
        "",
        "0"
    );
    await callHistoryDAO.insertCallHistoryRecord(data);
  }
  void insertCallEndDetailInDB(SocketMessageModel socketMessageModel,String targetId) async
  {
    var now =  DateTime.now();
    final db =  await AFJDatabaseInstance.instance.afjDatabase;
    final personDao = db?.callHistoryDAO as CallHistoryDAO;
    print("store data caller ID => ${targetId}");

    var storedData = await personDao.getLastSingleCallHistoryRecord(targetId);
    print("store data => ${storedData?.callTime.toString()}");
     if(storedData != null)
     {
       storedData.isMissedCall = false;
       storedData.endCallTime = Controller().getConvertedDate(now);
       storedData.totalCallTime =getTimeDiff(storedData.callTime);
       await personDao.updateCallHistoryRecord(storedData);
     }
  }



  String getTimeDiff(String checkIn)
  {

        DateFormat dateFormat =  DateFormat.Hm();
        DateTime now = DateTime.now();
        DateTime open = dateFormat.parse(checkIn);
        open = DateTime(now.year, now.month, now.day, open.hour, open.minute);
        return calculateDuration(now.difference(open));
  }

  String calculateDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

}
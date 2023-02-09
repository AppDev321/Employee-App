import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hnh_flutter/database/dao/attachments_dao.dart';
import 'package:hnh_flutter/database/dao/conversation_dao.dart';
import 'package:hnh_flutter/database/dao/download_status_dao.dart';
import 'package:hnh_flutter/database/dao/user_dao.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';
import 'package:hnh_flutter/database/model/user_table.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../database/dao/call_history_dao.dart';
import '../database/dao/messages_dao.dart';
import '../database/database_single_instance.dart';
import '../database/model/attachment_file_status_table.dart';
import '../database/model/call_history_table.dart';
import '../database/model/messages_table.dart';
import '../pages/chat/component/attachment_box_widget.dart';
import '../repository/model/request/socket_message_model.dart';
import '../repository/model/response/contact_list.dart';
import '../utils/controller.dart';

class CustomMessageObject {
  String userName;
  String userPicture;
  int senderId;
  int receiverid;
  int conversationId;


  CustomMessageObject(
      {required this.userName,
      required this.userPicture,
      required this.senderId,
      required this.receiverid,
      required this.conversationId});
}

class ChatViewModel extends BaseViewModel {

  static bool showNotificationFromDashboard = true;


  Future<List<UserTable>> getContactDBList() async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final userDAO = db?.userTableDAO as UserTableDAO;
    return userDAO.getAllUser();
  }

  Future<List<User>> getContactList() async {
    final results = await APIWebService().getContactList();
    final listData = results?.data?.contacts as List<User>;

    insertContactList(listData);
    return listData;
  }

  Future<List<CallHistoryTable>> getCallHistoryList() async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final callHistoryDao = db?.callHistoryDAO as CallHistoryDAO;
    return await callHistoryDao.getAllCallHistory();
  }

  void insertConversationData( int? senderID,int? receiverID, Function(ConversationTable) callback) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final conversationTableDao =
        db?.conversationTableDAO as ConversationTableDAO;
    var userData =
        ConversationTable(senderID: senderID, receiverID: receiverID,);

    var now = DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);
    String formattedTime = Controller().getConvertedTime(now);
    userData.date = formattedDate;
    userData.time = formattedTime;

    conversationTableDao.getReceiverRecord(receiverID!).then((value) {

      if (value != null) {
        userData = value;
        callback(value);
      } else {
        conversationTableDao.insertConversationRecord(userData).then((value) {
          conversationTableDao.getReceiverRecord(receiverID).then((newRecord) {
            userData = newRecord!;
            callback(newRecord);
          });
        });
      }
    });
  }

  Future<void> insertLastMessageIDConversation(int recieverid,{bool? isNewMessage=false}) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final conversationTableDao =
        db?.conversationTableDAO as ConversationTableDAO;

    var record = await conversationTableDao.getReceiverRecord(recieverid);
    if (record != null) {
      var latestMessage = await getLastMessageIDByReceiver(recieverid);
      if (latestMessage != null) {
        record.lastMessageID = latestMessage.id;
        record.isNewMessage = isNewMessage;



        var now = DateTime.now();
        String formattedDate = Controller().getConvertedDate(now);
        String formattedTime = Controller().getConvertedTime(now);
        record.date = formattedDate;
        record.time = formattedTime;

        await conversationTableDao.updateConversationRecord(record);
      }
    }
  }

  Future<void> updateConversationData(ConversationTable table) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final conversationTableDao =
        db?.conversationTableDAO as ConversationTableDAO;
    await conversationTableDao.updateConversationRecord(table);
  }

  void deleteConversation(List<ConversationTable> data) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final conversationTableDAO =
        db?.conversationTableDAO as ConversationTableDAO;
    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    final attachmentsTableDAO = db?.attachmentTableDAO as AttachmentsTableDAO;
    for (var item in data) {
      await conversationTableDAO.deleteConversationRecord(item.id as int);
      await messagesTableDAO.deleteAllConversationMessage(item.id as int);
      await attachmentsTableDAO.deleteConversationAttachment(item.id as int);
    }
  }

  Future<MessagesTable?> getLastMessageIDByReceiver(int recieverid) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    return await messagesTableDAO.getLastMessageRecordByReceiverID(recieverid);
  }

  Future<List<ConversationTable>> getConversationList() async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final conversationTableDAO =
        db?.conversationTableDAO as ConversationTableDAO;
    return await conversationTableDAO.getAllConversation();
  }

  //inserting data on messages table
  Future<MessagesTable> insertMessagesData(
      {String? msg,
      CustomMessageObject? customMessageObject,
      bool? isMine,
      bool? hasAttachment = false,
      MessagesTable? messageRecord}) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    var now = DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);
    String formattedTime = Controller().getConvertedTime(now);



    var userData = messageRecord ??   MessagesTable(
            conversationID: customMessageObject!.conversationId,
            content: msg,
            senderID: customMessageObject.senderId,
            receiverID: customMessageObject.receiverid,
            date: formattedDate,
            time: formattedTime,
            isMine: isMine,
            isAttachments: hasAttachment,
            deliveryStatus: false);



    await messagesTableDAO.insertMessagesRecord(userData);
    userData = await getLastMessageIDByReceiver(customMessageObject!.receiverid) as MessagesTable;

    return userData;
  }



  Future<MessagesTable?> getSingleMessageRecord(int id) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    return await messagesTableDAO.getMessagesRecord("$id");
  }

  Future<List<MessagesTable>> getMessagesList(int conversationID) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    return await messagesTableDAO.getAllMessages(conversationID);
  }

  void deleteMessages(List<MessagesTable> data) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;

    final messagesTableDAO = db?.messagesTableDAO as MessagesTableDAO;
    final attachmentsTableDAO = db?.attachmentTableDAO as AttachmentsTableDAO;
    for (var item in data) {
      await messagesTableDAO.deleteMessagesRecord(item.id as int);
      await attachmentsTableDAO.deleteMessageAttachment(item.id as int);
    }
  }

  //insert data to attachment table

  Future<AttachmentsTable> insertAttachmentsData(
      AttachmentsTable item, int receiverId, Function(int) msgID) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final attachmentsTableDAO = db?.attachmentTableDAO as AttachmentsTableDAO;

    var latestMessage =  await getLastMessageIDByReceiver(receiverId);
    if (latestMessage != null) {
      item.messageID = latestMessage.id;
      msgID(latestMessage.id!);
    }
    await attachmentsTableDAO.insertAttachmentsRecord(item);
    return item;
  }

  //insert data in contacts table
  void insertContactList(List<User> contactList) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final userTableDao = db?.userTableDAO as UserTableDAO;
    await userTableDao.deleteAllUser();

    for (int i = 0; i < contactList.length; i++) {
      var data = contactList[i];
      var userData = UserTable(
          userID: data.id,
          fullName: data.fullName,
          email: data.email,
          picture: data.picture);
      await userTableDao.insertUserRecord(userData);
    }
  }

  Future<UserTable?> getSingleUserRecord(String id) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final userTableDao = db?.userTableDAO as UserTableDAO;
    return await userTableDao.getUserRecord(id);
  }

  Future<AttachmentsTable?> getSingleAttachmentByMsgID(int messageID) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final attachmentsTableDAO = db?.attachmentTableDAO as AttachmentsTableDAO;
    return await attachmentsTableDAO.getAttachmentByMsgId(messageID);
  }

 Future<AttachmentsTable> updateAttachment(AttachmentsTable item) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final attachmentsTableDAO = db?.attachmentTableDAO as AttachmentsTableDAO;
  await attachmentsTableDAO.updateAttachmentsRecord(item);

    return item;
  }

  void insertCallDetailInDB(SocketMessageModel socketMessageModel) async {
    var now = DateTime.now();
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final callHistoryDAO = db?.callHistoryDAO as CallHistoryDAO;
    var data = CallHistoryTable(
        socketMessageModel.sendFrom.toString(),
        "",
        socketMessageModel.callerName.toString(),
        socketMessageModel.callType.toString(),
        false,
        false,
        Controller().getConvertedDate(now),
        Controller().getConvertedTime(now),
        "",
        "0");
    await callHistoryDAO.insertCallHistoryRecord(data);
  }

  void insertCallEndDetailInDB(
      SocketMessageModel socketMessageModel, String targetId) async {
    var now = DateTime.now();
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final personDao = db?.callHistoryDAO as CallHistoryDAO;
    Controller().printLogs("store data caller ID => ${targetId}");

    var storedData = await personDao.getLastSingleCallHistoryRecord(targetId);
    Controller().printLogs("store data => ${storedData?.callTime.toString()}");
    if (storedData != null) {
      storedData.isMissedCall = false;
      storedData.endCallTime = Controller().getConvertedDate(now);
      storedData.totalCallTime = getTimeDiff(storedData.callTime);
      await personDao.updateCallHistoryRecord(storedData);
    }
  }

  String getTimeDiff(String checkIn) {
    DateFormat dateFormat = DateFormat.Hm();
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

  void insertDownloadFileData(int downloadID) async {
    final db = await AFJDatabaseInstance.instance.afjDatabase;
    final downloadDao = db?.downloadTableDAO as DownloadTableDAO;
    downloadDao.getDownloadRecord(downloadID).then((value) {
      if (value != null) {
      } else {
        var downloadData = DownloadStatusTable(
            type: "upload", percentage: 0.0, isCompleted: false, fileSize: 0);
        downloadDao.insertDownloadRecord(downloadData).then((value) {});
      }
    });
  }

  handleSocketCallbackMessage(SocketMessageModel message, {ValueChanged<dynamic>? messageTable,ValueChanged<dynamic>? conversationTable}) {
    var msgType = message.type.toString();
    var body = json.encode(message.data);
    var body2 = json.decode(body);
    if (msgType == SocketMessageType.Received.displayTitle) {
      var item = MessagesTable.fromJson(body2);
      var senderID = item.receiverID;
      var receiverID = item.senderID;
      var newObject = item;
      newObject.isMine = false;
      newObject.senderID = senderID;
      newObject.receiverID = receiverID;
     insertConversationData(senderID, receiverID, (conversationData) async{
        newObject.conversationID = conversationData.id;

        await  insertMessagesData(messageRecord: newObject);
        if(messageTable!=null) {
          messageTable(newObject);
        }
        if(conversationTable != null) {
          conversationTable(conversationData);
        }
      });
    }
    else if(msgType == SocketMessageType.ReceivedAttachment.displayTitle)
    {
      var msgTable = body2['messageTable'];
      var attachmentTable = body2['attachmentTable'];
      var item = MessagesTable.fromJson(msgTable);
      var senderID = item.receiverID;
      var receiverID = item.senderID;
      var newObject = item;
      newObject.isMine = false;
      newObject.senderID = senderID;
      newObject.receiverID = receiverID;
      //First check conversation is exits or not then use its id in message table
     insertConversationData(senderID, receiverID, (conversationData) async{
        newObject.conversationID = conversationData.id;
        await insertMessagesData(messageRecord: newObject);
        //Secondly create attachment table using message id
        var itemAttachment = AttachmentsTable.fromJson(attachmentTable);

        await insertAttachmentsData( itemAttachment,receiverID!, (msgID) {
            newObject.id = msgID;

            if(messageTable!=null) {
              messageTable(newObject);
            }
            if(conversationTable != null) {
              conversationTable!(conversationData);
            }

        });

      });
    }

  }

  Widget showMessageContentView(MessagesTable item,[bool isMineSide = true]) {
    if (item.isAttachments == false) {
      return Text(
        item.content.toString(),
        style: const TextStyle(
          fontSize: 16,
        ),
      );
    } else {
      return FutureBuilder(
          future: getSingleAttachmentByMsgID(item.id!),
          builder: (context, snap)
          {

            if (snap.hasData) {
              var data = snap.data as AttachmentsTable;
              final type = data.attachmentType.toString();
              return isMineSide? AttachmentWidget(item: data,isDonwload: false) :AttachmentWidget(item: data,isDonwload: true);

            } else {
              return CircularProgressIndicator();
            }
          });
    }
  }


}

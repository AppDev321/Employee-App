import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';
import 'package:hnh_flutter/database/model/user_table.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';

import '../../../database/model/messages_table.dart';
import '../chat_detail.dart';

class ConversationList extends StatefulWidget {
  final ConversationTable conversationData;
  ValueChanged<CustomMessageObject> callBack;

  ConversationList({Key? key, required this.conversationData,required this.callBack})
      : super(key: key);

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  late ConversationTable conversationTable;
  late UserTable? userData;
  String lastMessageData = '';

  ChatViewModel chatViewModel = ChatViewModel();
  bool isDataExit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecordFromDB();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    getRecordFromDB();
  }

  getRecordFromDB() async {
    conversationTable = widget.conversationData;
    var receiverID = conversationTable.receiverID.toString();
    userData = await chatViewModel.getSingleUserRecord(receiverID);
    conversationTable.receiverName = userData!.fullName.toString();
    chatViewModel.updateConversationData(conversationTable);

    if (conversationTable.lastMessageID != null) {
      var messageData = await chatViewModel.getSingleMessageRecord(
          conversationTable.lastMessageID!) as MessagesTable;
      lastMessageData = messageData.content ?? '';
    }
    setState(() {
      isDataExit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      // widget.isMultiSelectionEnabled?
      isDataExit
        ? GestureDetector(
            onTap: () {
              var data = CustomMessageObject(
                  userName: userData!.fullName.toString(),
                  conversationId: conversationTable.id!,
                  senderId: conversationTable.senderID!,
                  receiverid: conversationTable.receiverID!,
                  userPicture: userData!.picture.toString());
              widget.callBack(data);
             // Get.to(() => ChatDetailPage(item: data));
              //   Get.to(() =>  IndividualChats());
            },

            child: Container(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        conversationTable.isNewMessage == true
                            ? Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                alignment: Alignment.center,
                                child: Center())
                            : Center(),
                        const SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(userData?.picture ?? ""),
                          maxRadius: 25,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  userData!.fullName.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  lastMessageData,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(userData!..toString(),style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead!?FontWeight.bold:FontWeight.normal),),
                ],
              ),
            ),
          )
        : Container()
          // :
          // Center()
    ;
  }
}

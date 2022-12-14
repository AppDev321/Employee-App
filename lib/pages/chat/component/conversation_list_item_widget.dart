import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';
import 'package:hnh_flutter/database/model/user_table.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import '../chat_detail.dart';

class ConversationList extends StatefulWidget {
  final ConversationTable conversationData;

  ConversationList({required this.conversationData});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  late ConversationTable conversationTable;
  late UserTable? userData;

  ChatViewModel chatViewModel = ChatViewModel();
  bool isDataExit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    conversationTable = widget.conversationData as ConversationTable;

    var receiverID = conversationTable.receiverID.toString();

    chatViewModel.getSingleUserRecord(receiverID).then((value) {
      userData = value;
        setState(() {
          isDataExit = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {

    return
      isDataExit?
    GestureDetector(
      onTap: () {
        var data = CustomMessageObject(userName: userData!.fullName.toString(),
            conversationId: conversationTable.id!,
            senderId: conversationTable.senderID!,
        receiverid: conversationTable.receiverID!,
        userPicture: userData!.picture.toString());
        Get.to(() =>  ChatDetailPage(item: data));
        //   Get.to(() =>  IndividualChats());
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(userData?.picture ?? ""),
                    maxRadius: 30,
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
                          Text(userData!.fullName.toString(), style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 6,),
                          Text(userData!.email.toString(),style: TextStyle(fontSize: 13,color: Colors.grey.shade600, ),),
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
    ):Container();
  }
}
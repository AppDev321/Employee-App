import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/database/model/messages_table.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../repository/model/request/socket_message_model.dart';
import '../../utils/controller.dart';
import '../../websocket/service/socket_service.dart';
import 'component/chat_input_box.dart';
import 'component/own_message_box.dart';
import 'component/reply_message_box.dart';

class ChatDetailPage extends StatefulWidget {
  final CustomMessageObject item;

  ChatDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {
  ChatViewModel chatViewModel = ChatViewModel();
  List<MessagesTable> messagesList = [];
  ScrollController _scrollController = ScrollController();
  SocketService socketService = SocketService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatViewModel.getMessagesList(widget.item.conversationId).then((value) {
      setState(() {
        var data = value;
        messagesList = data;
      //  _scrollDown();
      });
    });

    //Handle web socket msg
    FBroadcast.instance().register(Controller().socketMessageBroadCast,
          (socketMessage, callback)
      async {
        chatViewModel.handleSocketCallbackMessage(socketMessage,(data){
          setState(() {
            messagesList.add(data);
          });
        });
      } ,context: this);


    //tgy

  }



  @override
  void dispose() {

    FBroadcast.instance().unregister(this);

    chatViewModel.insertLastMessageIDConversation(
        widget.item.receiverid);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.item.userPicture),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomTextWidget(
                            text: widget.item.userName,
                            size: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        const SizedBox(
                          height: 6,
                        ),
                        CustomTextWidget(
                            text: "Online",
                            size: 13,
                            color: Colors.grey.shade100,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.videocam,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(child: getChatList()),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatInputBox(
                      item: widget.item,
                      attachmentInsertedCallback: (path) {
                        var attachmentData = path as AttachmentsTable;
                        debugPrint(" Path : ${attachmentData.attachmentUrl}");
                      },
                      onTextMessageSent: (msg) {
                        setState(() {
                          chatViewModel.insertLastMessageIDConversation(
                              widget.item.receiverid);
                          messagesList.add(msg);
                          _scrollDown();

                          if(msg.isAttachments== false) {
                            var message = SocketMessageModel(
                                type: SocketMessageType.Send.displayTitle,
                                sendTo: widget.item.receiverid.toString(),
                                sendFrom: widget.item.senderId.toString(),
                                data: msg);

                            socketService.sendMessageToWebSocket(message);
                          }



                        });
                      }))
            ],
          ),
        ));
  }

  void _scrollDown() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
    });
  }

  Widget getChatList() {
    return ListView.builder(

      itemCount: messagesList.length + 1,
      shrinkWrap: true,
      //physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      padding: const EdgeInsets.only(left: 5,right: 5),
      itemBuilder: (context, index) {
        if (index == messagesList.length) {
          return Container(
            height: 20,
          );
        } else {
          var item = messagesList[index];
          if (item.isMine == true) {
            return OwnMessageCard(
              item: item,
            );
          } else {

            return ReplyCard(
              item: item,
            );
          }
        }
      },
    );
  }
}

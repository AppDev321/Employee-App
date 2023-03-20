import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/database/model/attachments_table.dart';
import 'package:hnh_flutter/database/model/messages_table.dart';
import 'package:hnh_flutter/pages/videocall/audio_call_screen.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../notification/firebase_notification.dart';
import '../../repository/model/request/socket_message_model.dart';
import '../../utils/controller.dart';
import '../../websocket/service/socket_service.dart';
import '../videocall/video_call_screen.dart';
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
  HashSet<MessagesTable> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;

  late Future<List<MessagesTable>> databaseMessageList;
  StreamController<MessagesTable> messageStream = StreamController<MessagesTable>.broadcast();

  Future<List<MessagesTable>> fetchDatabaseMsg() async {
  final messages =   await chatViewModel.getMessagesList(widget.item.conversationId);
    for (var message in messages) {
    //  messageStream.sink.add(message);
    }


    return messages;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseMessageList = fetchDatabaseMsg();
   /* chatViewModel.getMessagesList(widget.item.conversationId).then((value) {
      setState(() {
        var data = value;
        messagesList = data;

      });


    });*/

    //Handle web socket msg
    FBroadcast.instance().register(Controller().socketMessageBroadCast,
          (socketMessage, callback)
      async {
        chatViewModel.handleSocketCallbackMessage(socketMessage, messageTable: (msgData){
          var data = msgData as MessagesTable;
          if(data.receiverID == widget.item.receiverid) {
            /*setState(() {
              messagesList.add(data);
            });
*/
            messageStream.sink.add(data);
          }
          else
            {
              LocalNotificationService.customNotification(data.receiverID! );
            }
        },conversationTable: (conversationData) async{
          await chatViewModel.insertLastMessageIDConversation(conversationData.receiverID!,isNewMessage: true);
        });
      } ,context: this);
  }

  @override
  void dispose() {
    FBroadcast.instance().unregister(this);

   messageStream.close();
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
          flexibleSpace:

          SafeArea(
            child:
            Container(
              padding: const EdgeInsets.only(right: 16),
              child:
              selectedItem.isEmpty?
              Row(
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


             Row(children: [
                 InkWell(
                   onTap: (){
                     Get.to(() => VideoCallScreen(
                         targetUserID: widget.item.receiverid.toString()));
                   },

                   child: const Icon(
                     Icons.videocam,
                     color: Colors.white,
                   ),
                 ),
                 SizedBox(
                   width: 20,
                 ),
                 InkWell(
                   onTap: (){
                     Get.to(() => AudioCallScreen(
                         targetUserID: widget.item.receiverid.toString()));
                   },
                   child: const Icon(
                     Icons.call,
                     color: Colors.white,
                   ),
                 ),
               ],)
                ],
              )
                  :
              Row(
                children: <Widget>[
                  IconButton(
                      color: Colors.white,
                      onPressed: () {
                        selectedItem.clear();
                        isMultiSelectionEnabled = false;
                        setState(() {});
                      },
                      icon: Icon(Icons.close)),
                  Expanded(
                    child: CustomTextWidget(
                        text: getSelectedItemCount(),
                        color: Colors.white,
                        size: 20,
                        fontWeight: FontWeight.w400),
                  ),
                  Row(children: [
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Controller().showMessageDialog(context,
                          "Are you sure you want to delete ?","Delete",
                              (){
                            chatViewModel.deleteMessages(selectedItem.toList());
                            for (var nature in selectedItem) {
                              messagesList.remove(nature);
                            }
                            isMultiSelectionEnabled = false;
                            selectedItem.clear();
                            setState(() {});
                            Navigator.of(context, rootNavigator: true).pop('dialog');
                          },);
                      },
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    )
                  ],)
                ],
              ),
            ),
          )
        ),
        body: Column(
          children: [
            Expanded(child:
                getChatList()
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ChatInputBox(
                    item: widget.item,
                    attachmentInsertedCallback: (path) {
                      var attachmentData = path as AttachmentsTable;
                      Controller().printLogs(" Path : ${attachmentData.attachmentUrl}");
                    },
                    onTextMessageSent: (msg) {
                      setState(() {
                        chatViewModel.insertLastMessageIDConversation(
                            widget.item.receiverid);
                      //  messagesList.add(msg);
                        messageStream.sink.add(msg);

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
        ));
  }


  Widget getChatList() {
    return
          FutureBuilder<List<MessagesTable>>(
            future: databaseMessageList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final messages = snapshot.data as List<MessagesTable>;

                  return StreamBuilder<MessagesTable>(
                    stream: messageStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var message = snapshot.data as MessagesTable;

                        messages.add(message);
                      }

                      final itemCount = messages.length + 1;
                      final shouldReverse = itemCount > 5;

                      return
                        ListView.builder(
                            reverse:  shouldReverse ,
                            itemCount: itemCount,
                            shrinkWrap: true,
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (context, index) {
                              final isLastItem = index == messages.length;

                              if (isLastItem) {
                                return Container(height: 20);
                              }

                              final item = messages[shouldReverse ? itemCount - index - 2 : index];

                              return InkWell(
                                onTap: () => doMultiSelection(item),
                                onLongPress: () => setState(() {
                                  isMultiSelectionEnabled = true;
                                  doMultiSelection(item);
                                }),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    if (item.isMine = true) OwnMessageCard(item: item)
                                    else ReplyCard(item: item),
                                    Visibility(
                                      visible: isMultiSelectionEnabled,
                                      child: Icon(
                                        selectedItem.contains(item) ? Icons.check_circle : Icons.radio_button_unchecked,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('No messages found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          );
  }
/*
  Widget getChatList() {
    final itemCount = messagesList.length + 1;
    final shouldReverse = itemCount > 5;

    return ListView.builder(
      reverse: shouldReverse,
      itemCount: itemCount,
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      itemBuilder: (context, index) {
        final isLastItem = index == messagesList.length;

        if (isLastItem) {
          return Container(height: 20);
        }

        final item = messagesList[shouldReverse ? itemCount - index - 2 : index];

        return InkWell(
          onTap: () => doMultiSelection(item),
          onLongPress: () => setState(() {
            isMultiSelectionEnabled = true;
            doMultiSelection(item);
          }),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (item.isMine = true) OwnMessageCard(item: item)
              else ReplyCard(item: item),
              Visibility(
                visible: isMultiSelectionEnabled,
                child: Icon(
                  selectedItem.contains(item) ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 30,
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

  void doMultiSelection(item) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(item)) {
        selectedItem.remove(item);
      } else {
        selectedItem.add(item);
      }
      setState(() {});
    } else {
      //Other logic
    }
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? "${selectedItem.length} item selected"
        : "No item selected";
  }
}

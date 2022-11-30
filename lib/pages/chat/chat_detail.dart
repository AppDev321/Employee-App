import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/pages/chat/component/chat_bubble.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../custom_style/colors.dart';
import '../../repository/model/request/chat_messge.dart';
import 'component/chat_input_box.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage>
    with SingleTickerProviderStateMixin {


  late AnimationController controller;
  List<ChatMessage> messages = [
    ChatMessage("Hello, Will", "receiver"),
    ChatMessage("How have you been?", "receiver"),
    ChatMessage("Hey Kriss, I am doing fine dude. wbu?", "sender"),
    ChatMessage("ehhhh, doing OK.", "receiver"),
    ChatMessage("Is there any thing wrong?", "sender"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

  }

  @override
  void dispose() {
    controller.dispose();
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
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/5.jpg"),
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
                      const CustomTextWidget(
                          text: "Kriss Benwat",
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
                SizedBox(width: 20,),
                const Icon(
                  Icons.call,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [

        getChatList(),
        Positioned(
            child:
        Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            width: double.infinity,
            child: ChatInputBox(recordingFinishedCallback: (path){
              print("audio file : $path");
            },
              onTextMessageSent: (msg){
                print("Text Msg: $msg");
              },)))],)

      // Container(height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,color: Colors.black,),
      // body: Stack(
      //   children: <Widget>[
      //      getChatList(),

      //     ),
      //   ],
      // ),
    );
  }

  Widget getChatList() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ChatBubble(true, 1,voice: true,);
       // ChatBubble(true, 2);
       // ChatBubble(false, 3,voice: true,);

          Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (messages[index].messageType == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messages[index].messageType == "receiver"
                    ? cardDarkThemeBg
                    : primaryColor),
              ),
              padding: const EdgeInsets.all(16),
              child: CustomTextWidget(
                text: messages[index].messageContent,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }


}

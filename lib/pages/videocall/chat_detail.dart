import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../custom_style/colors.dart';
import '../../repository/model/request/chat_messge.dart';
import '../../widget/glowing_action_button_widget.dart';

class ChatDetailPage extends StatefulWidget {
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  List<ChatMessage> messages = [
    ChatMessage("Hello, Will", "receiver"),
    ChatMessage("How have you been?", "receiver"),
    ChatMessage("Hey Kriss, I am doing fine dude. wbu?", "sender"),
    ChatMessage("ehhhh, doing OK.", "receiver"),
    ChatMessage("Is there any thing wrong?", "sender"),
  ];

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
                      "<https://randomuser.me/api/portraits/men/5.jpg>"),
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
                  Icons.call,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          getChatList(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: cardThemeBaseColor,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    child:
                        const Icon(Icons.send, color: Colors.white, size: 18),
                    backgroundColor: primaryColor,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getChatList() {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
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
              padding: EdgeInsets.all(16),
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

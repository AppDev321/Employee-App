import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:line_icons/line_icons.dart';

import '../../custom_style/colors.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/chat_user.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/conversation_list_item_widget.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {

  List<ChatUsers> chatUsers = [
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg","Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg", "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg", "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins", "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome", "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening", "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?", "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg","Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg", "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg", "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins", "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome", "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening", "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?", "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg","Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg", "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg", "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins", "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome", "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening", "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?", "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: const Text("Video Chat"),

      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context,_)=>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const CustomTextWidget(text: "Conversations",size: 32,fontWeight: FontWeight.bold),
                      TextColorContainer(
                          label: "Add New",
                          color: Colors.red),

                    ],
                  ),
                ),
              ),

            ],
          body:


          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child:   CustomEditTextWidget(
                  text: "Search...",
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView.builder(
                        itemCount: chatUsers.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return ConversationList(
                            name: chatUsers[index].name,
                            messageText: chatUsers[index].messageText,
                            imageUrl: chatUsers[index].imageURL,
                            time: chatUsers[index].time,
                            isMessageRead: (index == 0 || index == 3)?true:false,
                          );
                        },
                      ),
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

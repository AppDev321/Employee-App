import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:hnh_flutter/widget/error_message.dart';

import '../../custom_style/colors.dart';
import '../../database/model/call_history_table.dart';
import '../../repository/model/request/chat_user.dart';
import '../../repository/model/response/contact_list.dart';
import '../../utils/controller.dart';
import '../../view_models/chat_vm.dart';
import '../../widget/color_text_round_widget.dart';
import '../videocall/video_call_screen.dart';
import 'component/call_history_list_widget.dart';
import 'component/contact_list_widget.dart';
import 'component/conversation_list_item_widget.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  List<ChatUsers> chatUsers = [
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg", "Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg",
        "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg",
        "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins",
        "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome",
        "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening",
        "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?",
        "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg", "Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg",
        "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg",
        "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins",
        "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome",
        "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening",
        "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?",
        "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
    ChatUsers("Jane Russel", "Awesome Setup", "images/userImage1.jpeg", "Now"),
    ChatUsers("Glady's Murphy", "That's Great", "images/userImage2.jpeg",
        "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "images/userImage3.jpeg",
        "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins",
        "images/userImage4.jpeg", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome",
        "images/userImage5.jpeg", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening",
        "images/userImage6.jpeg", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?",
        "images/userImage7.jpeg", "24 Feb"),
    ChatUsers("John Wick", "How are you?", "images/userImage8.jpeg", "18 Feb"),
  ];
  var selectedTab = 0;
  late ChatViewModel chatViewModel;
  String? _errorMsg = "";

  List<User> contactList = [];
  List<User> filteredContactList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatViewModel = ChatViewModel();
    chatViewModel.addListener(() {
      var checkErrorApiStatus = chatViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _errorMsg = chatViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
          }
        });
      } else {
        setState(() {
          _errorMsg = "";
          //  contactList = chatViewModel.listUser;
          //filteredContactList = contactList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Video Chat"),
        ),
        body: selectedTab == 0
            ? setConversationList()
            : selectedTab == 1
                ? setContactList()
                : setCallHistoryList(),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              setState(() {
                selectedTab = index;
              });
            },
            currentIndex: selectedTab,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(label: "Chat", icon: Icon(Icons.chat)),
              BottomNavigationBarItem(
                  label: "Contact", icon: Icon(Icons.perm_contact_cal)),
              BottomNavigationBarItem(
                  label: "Call History", icon: Icon(Icons.call)),
            ]));
  }

  Widget setConversationList() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const CustomTextWidget(
                      text: "Conversation",
                      size: 32,
                      fontWeight: FontWeight.bold),
                  TextColorContainer(label: "Add New", color: Colors.red),
                ],
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomEditTextWidget(
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
                      itemBuilder: (context, index) {
                        return ConversationList(
                          name: chatUsers[index].name,
                          messageText: chatUsers[index].messageText,
                          imageUrl: chatUsers[index].imageURL,
                          time: chatUsers[index].time,
                          isMessageRead:
                              (index == 0 || index == 3) ? true : false,
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
    );
  }

  Widget setContactList() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomEditTextWidget(
              text: "Search...",
              onTextChanged: (text) {
                print("filter texting ==> ${filteredContactList.length}");
                searchFromContactList(text);
              },
            ),
          ),
          filteredContactList.isEmpty ?
          FutureBuilder(
                  future:getContactList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Expanded(child:
                      Center(child: ErrorMessageWidget(label: "${snapshot.error}")));
                    } else if (snapshot.hasData) {
                      contactList = snapshot.data as List<User>;
                      filteredContactList = snapshot.data as List<User>;
                      return showContactListItems(filteredContactList);
                    } else {
                      return const Expanded(
                          child: Center(child: CircularProgressIndicator()));
                    }
                  })
              : showContactListItems(filteredContactList),
        ],
      ),
    );
  }

  Future<Object> getContactList() async
  {
    return contactList.isEmpty?chatViewModel.getContactList():contactList;
  }


  Widget showContactListItems(List<User> filteredContactList) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:

        ContactListItem(filteredContactList:filteredContactList)

      ),
    );
  }

  Widget setCallHistoryList() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: CallHistoryListWidget(futureFunction: chatViewModel.getCallHistoryList()));
  }

  searchFromContactList(String text) async {

 //  filteredContactList.clear();
    if (text.isEmpty) {
      setState(() {
        filteredContactList  = contactList;
      });
      return;
    }
    setState(() {
      filteredContactList = contactList
          .where((string) => string.fullName
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    });
  }
}

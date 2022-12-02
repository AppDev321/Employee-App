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
import '../../database/model/user_table.dart';
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
    ChatUsers("Jane Russel", "Awesome Setup", "", "Now"),
    ChatUsers("Glady's Murphy", "That's Great", "",
        "Yesterday"),
    ChatUsers("Jorge Henry", "Hey where are you?", "",
        "31 Mar"),
    ChatUsers("Philip Fox", "Busy! Call me in 20 mins",
        "", "28 Mar"),
    ChatUsers("Debra Hawkins", "Thankyou, It's awesome",
        "", "23 Mar"),
    ChatUsers("Jacob Pena", "will update you in evening",
        "", "17 Mar"),
    ChatUsers("Andrey Jones", "Can you please share the file?",
        "", "24 Feb"),

  ];
  var selectedTab = 0;
  late ChatViewModel chatViewModel;
  String? _errorMsg = "";
  late List<ChatUsers> filteredChatList;
  List<UserTable> contactList = [];
  List<UserTable> filteredContactList = [];
  TextEditingController messagesController = TextEditingController();
  TextEditingController callController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    chatViewModel = ChatViewModel();


    getContactList().then((value) {
      setState(() {
        var data = value as List<UserTable>;
        contactList = data;
        filteredContactList = data;
        print("list size = ${data.length}");

      });
    }) ;


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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messagesController.dispose();
    callController.dispose();
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
    filteredChatList = searchFromMessageList(messagesController.text);
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
                controller: messagesController,
                onTextChanged: (value) {
                setState(() {
                });
                },
              ),
            ),

            filteredChatList.isNotEmpty?
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                      itemCount: filteredChatList.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var item = filteredChatList[index];
                        // String name=chatUsers[index].name;
                        // if(messagesController.text.isEmpty){
                          return
                            ConversationList(
                            name: item.name.toString(),
                            messageText: item.messageText,
                            imageUrl: item.imageURL,
                            time: item.time,
                            isMessageRead:
                            (index == 0 || index == 3) ? true : false,
                          );
                        // }
                        // else if(name.toLowerCase().contains(messagesController.text.toLowerCase())){
                        //   return ConversationList(
                        //     name: chatUsers[index].name,
                        //     messageText: chatUsers[index].messageText,
                        //     imageUrl: chatUsers[index].imageURL,
                        //     time: chatUsers[index].time,
                        //     isMessageRead:
                        //     (index == 0 || index == 3) ? true : false,
                        //   );
                        // }
                        // else {
                        //   return Center(
                        //     // child: Text("data"),
                        //   );
                        // }
                      },
                    )
                  ],
                ),
              ),
            ):
            Expanded(
                child: Center(
                  child: ErrorMessageWidget(
                    label: "No Contact Found",
                  ),
                ))
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
              controller: callController,
              text: "Search...",
              onTextChanged: (text) {
                setState(() {
                  //Just for updateing view not any else
                });
              },
            ),
          ),
          filteredContactList.isEmpty ?
              const ErrorMessageWidget(label: "No contact found")
              : showContactListItems(filteredContactList),
        ],
      ),
    );
  }

  Future<Object> getContactList() async
  {

    return contactList.isEmpty? chatViewModel.getContactDBList() :contactList;
  }


  Widget showContactListItems(List<UserTable> filteredContactList) {
    return Expanded(

      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:
        ContactListItem(filteredContactList:filteredContactList,controller: callController,)

      ),
    );
  }

  Widget setCallHistoryList() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: CallHistoryListWidget(futureFunction: chatViewModel.getCallHistoryList())
    );
  }

  searchFromMessageList(String text)  {
    //  filteredContactList.clear();
    if (text.isEmpty) {
      filteredChatList  = chatUsers;
    }
    else {
      filteredChatList = chatUsers
          .where((string) =>
          string.name
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
    return filteredChatList;
  }
}

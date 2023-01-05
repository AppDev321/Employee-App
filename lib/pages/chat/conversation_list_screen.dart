import 'dart:collection';
import 'dart:ui';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/database/model/conversation_table.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:hnh_flutter/widget/error_message.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../custom_style/colors.dart';
import '../../database/model/user_table.dart';
import '../../notification/firebase_notification.dart';
import '../../utils/controller.dart';
import '../../view_models/chat_vm.dart';
import 'chat_detail.dart';
import 'component/call_history_list_widget.dart';
import 'component/contact_list_widget.dart';
import 'component/conversation_list_item_widget.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  var selectedTab = 0;
  late ChatViewModel chatViewModel;
  String? _errorMsg = "";
  List<UserTable> contactList = [];
  List<UserTable> filteredContactList = [];
  TextEditingController messagesController = TextEditingController();
  TextEditingController callController = TextEditingController();
  List<ConversationTable> conversationList = [];
  List<ConversationTable> filteredConversationList = [];
  HashSet<ConversationTable> selectedItem = HashSet();
  bool isMultiSelectionEnabled = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ChatViewModel.showNotificationFromDashboard = false;
    chatViewModel = ChatViewModel();

    // getDataFromDB();

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

  Future getDataFromDB() async {
    //Handle web socket msg
    FBroadcast.instance().register(Controller().socketMessageBroadCast,
        (socketMessage, callback) async {
      chatViewModel.handleSocketCallbackMessage(socketMessage,
          conversationTable: (conversationData) async {
        var conv = conversationData as ConversationTable;
        await chatViewModel
            .insertLastMessageIDConversation(conv.receiverID!,
                isNewMessage: true)
            .then((value) {
          getDataFromDB();
        });
        LocalNotificationService.customNotification(
            conv.receiverID!);
      });
    }, context: this);

    var data = contactList.isEmpty
        ? await chatViewModel.getContactDBList()
        : contactList;
    var listConversation = await chatViewModel.getConversationList();
    if (data.isNotEmpty) {
      setState(() {
        contactList = data;
        filteredContactList = data;
        conversationList = listConversation;
        filteredConversationList = listConversation;

      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    messagesController.dispose();
    callController.dispose();

    ChatViewModel.showNotificationFromDashboard = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: isMultiSelectionEnabled? Text(getSelectedItemCount()): Text("Video Chat"),
          leading: isMultiSelectionEnabled
              ? IconButton(
              onPressed: () {
                selectedItem.clear();
                isMultiSelectionEnabled = false;
                setState(() {});
              },
              icon: Icon(Icons.close))
              : null,
          actions: [
            Visibility(
                visible: selectedItem.isNotEmpty,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Controller().showMessageDialog(context,
                      "Are you sure you want to delete ?","Delete",
                          (){
                            chatViewModel.deleteConversation(selectedItem.toList());
                            selectedItem.forEach((nature) {
                              conversationList.remove(nature);
                              filteredConversationList = conversationList;
                            });
                            isMultiSelectionEnabled = false;
                            selectedItem.clear();
                            setState(() {});
                         Navigator.of(context, rootNavigator: true).pop('dialog');

                      },);

                  },
                )
            ),
            Visibility(
                visible: selectedItem.isNotEmpty,
                child: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {},
                )),
            /*Visibility(
              visible: isMultiSelectionEnabled,
              child: IconButton(
                icon: Icon(
                  Icons.select_all,
                  color: selectedItem.length == natureList.length
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  if (selectedItem.length == natureList.length) {
                    selectedItem.clear();
                  } else {
                    for (int index = 0; index < natureList.length; index++) {
                      selectedItem.add(natureList[index]);
                    }
                  }
                  setState(() {});
                },
              )),*/
          ],

        ),
        body: VisibilityDetector(
          key: const Key('conversation-widget'),
          onVisibilityChanged: (VisibilityInfo info) {
            var isVisibleScreen = info.visibleFraction == 1.0 ? true : false;
            if (isVisibleScreen) {
              getDataFromDB();
            } else {
              FBroadcast.instance().unregister(this);
            }
          },
          child: Column(
            children: [
              Expanded(
                  child: selectedTab == 0
                      ? setConversationList()
                      : selectedTab == 1
                          ? setContactList()
                          : setCallHistoryList()),
            ],
          ),
        ),
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
    filteredConversationList = searchFromMessageList(messagesController.text);
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
                children: const <Widget>[
                  CustomTextWidget(
                      text: "Conversation",
                      size: 32,
                      fontWeight: FontWeight.bold),
                  // TextColorContainer(label: "Add New", color: Colors.red),
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
                  setState(() {});
                },
              ),
            ),
            filteredConversationList.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListView.builder(
                            itemCount: filteredConversationList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 16),
                            itemBuilder: (context, index) {
                              var item = filteredConversationList[index];
                              return InkWell(
                                  onTap: () {
                                   doMultiSelection(item);
                                  },
                                  onLongPress: () {
                                  setState(() {
                                    isMultiSelectionEnabled = true;
                                   doMultiSelection(item);
                                  });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:18.0),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        ConversationList(
                                            conversationData: item,

                                          callBack: (data){
                                              if(isMultiSelectionEnabled==false)
                                                {
                                                  Get.to(() => ChatDetailPage(item: data));
                                                }
                                          },
                                            ),
                                        Visibility(
                                        visible: isMultiSelectionEnabled,
                                        child: Icon(
                                          selectedItem.contains(item)
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          size: 30,

                                        ))
                                      ],
                                    ),
                                  ));
                            },
                          )
                        ],
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                    child: ErrorMessageWidget(
                      label: ConstantData.noDataFound,
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
                setState(() {});
              },
            ),
          ),
          filteredContactList.isEmpty
              ? const ErrorMessageWidget(label: ConstantData.noDataFound)
              : showContactListItems(filteredContactList),
        ],
      ),
    );
  }

  Widget showContactListItems(List<UserTable> filteredContactList) {
    return Expanded(
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ContactListItem(
            filteredContactList: filteredContactList,
            controller: callController,
            callBack: (data) {
              var conversationDAta = data as ConversationTable;
              setState(() {
                conversationList.add(conversationDAta);
                //filteredConversationList.add(conversationDAta);
              });
            },
          )),
    );
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? selectedItem.length.toString() + " item selected"
        : "No item selected";
  }

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

  Widget setCallHistoryList() {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: CallHistoryListWidget(
            futureFunction: chatViewModel.getCallHistoryList()));
  }

  searchFromMessageList(String text) {
    //  filteredContactList.clear();
    if (text.isEmpty) {
      filteredConversationList = conversationList;
    } else {
      filteredConversationList = conversationList
          .where((item) =>
          item.receiverName.toString().toLowerCase().contains(text.toLowerCase()))
          .toList();
    }
    return filteredConversationList;
  }
}

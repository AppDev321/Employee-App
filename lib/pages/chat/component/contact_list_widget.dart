import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/database/model/user_table.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:hnh_flutter/websocket/audio_video_call.dart';

import '../../../repository/model/response/contact_list.dart';
import '../../../utils/controller.dart';
import '../../../widget/error_message.dart';
import '../../videocall/video_call_screen.dart';
import '../chat_detail.dart';

typedef onBackConversationData = void Function(dynamic);

class ContactListItem extends StatefulWidget {
  List<UserTable> filteredContactList;
  TextEditingController controller;
  onBackConversationData callBack;

  ContactListItem(
      {required this.filteredContactList, required this.controller,required this.callBack});

  @override
  _ContactListItemState createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  late List<UserTable> contactList;
  late List<UserTable> filteredContactList;
  late final TextEditingController callController = widget.controller;
  int? senderID;
  late User userObject;
  late AudioVideoCall audioVideoCall;
  var chatViewModel = ChatViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredContactList = widget.filteredContactList;
    contactList = widget.filteredContactList;
    loadPreferenceUserData();
  }

  loadPreferenceUserData() async {
    User userData = User.fromJson(await Controller()
        .getObjectPreference(Controller.PREF_KEY_USER_OBJECT));

    setState(() {
      userObject = userData;
      senderID = int.parse(userObject.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredContactList = searchFromContactList(callController.text);
    return filteredContactList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredContactList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = filteredContactList[index];
              return createItem(item);
            },
          )
        : const Expanded(
            child: Center(
            child: ErrorMessageWidget(
              label: "No Contact Found",
            ),
          ));
  }
   searchFromContactList(String text)  {

    //  filteredContactList.clear();
    if (text.isEmpty) {
        filteredContactList  = contactList;
    }
  else {
      filteredContactList = contactList
          .where((string) =>
          string.fullName
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()))
          .toList();
    }
  return filteredContactList;
  }

  Widget createItem(UserTable item)
  {
   return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(
            left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(item.picture.toString()),
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
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.fullName.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {

                                chatViewModel.insertConversationData(
                                    senderID, item.userID!, (object) {
                                  widget.callBack(object);
                                  chatViewModel
                                      .getSingleUserRecord(
                                          object.receiverID.toString())
                                      .then((userData) {
                                    var data = CustomMessageObject(
                                        userName: userData!.fullName.toString(),
                                        conversationId: object.id!,
                                        senderId: object.senderID!,
                                        receiverid: object.receiverID!,
                                        userPicture:
                                            userData!.picture.toString());
                                    Get.to(() => ChatDetailPage(item: data));
                                  });
                                });
                              },
                              child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Icon(
                                    Icons.message,
                                    color: primaryColor,
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => VideoCallScreen(
                                    targetUserID: item.userID.toString()));
                              },
                              child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: Icon(
                                    Icons.call,
                                    color: primaryColor,
                                  )),
                            ),
                          ],
                        )
                      ],
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
}

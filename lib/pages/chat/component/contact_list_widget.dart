import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';

import '../../../repository/model/response/contact_list.dart';
import '../../../widget/error_message.dart';
import '../../videocall/video_call_screen.dart';

class ContactListItem extends StatefulWidget {
  List<User> filteredContactList;



  ContactListItem(
      {required this.filteredContactList});

  @override
  _ContactListItemState createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  late List<User> filteredContactList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredContactList = widget.filteredContactList;
  }

  @override
  Widget build(BuildContext context) {
    return filteredContactList.isNotEmpty
        ? ListView.builder(
            itemCount: filteredContactList.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = filteredContactList[index];
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
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => VideoCallScreen(
                                          targetUserID: item.id.toString()));
                                    },
                                    child: SizedBox(
                                        height: 45,
                                        width: 45,
                                        child: Icon(
                                          Icons.call,
                                          color: primaryColor,
                                        )),
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
            },
          )
        : Expanded(
            child: Center(
            child: ErrorMessageWidget(
              label: "No Contact Found",
            ),
          ));
  }
}

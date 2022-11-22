import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';


import '../../../repository/model/response/contact_list.dart';
import '../chat_detail.dart';

class ContactListItem extends StatefulWidget{
  String name;
  String imageUrl;
  final VoidCallback onUserItemClick;

  ContactListItem({
    required this.name,
    required this.imageUrl,
    required this.onUserItemClick
  });
  @override
  _ContactListItemState createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(() =>  ChatDetailPage());
     //   Get.to(() =>  IndividualChats());
      },

      child: Container(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.name, style: const TextStyle(fontSize: 16),),

                              InkWell(
                                onTap: widget.onUserItemClick,
                                child:

                                SizedBox(
                                    height: 45,
                                    width: 45,
                                    child: Icon(Icons.call,color: primaryColor,)),
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
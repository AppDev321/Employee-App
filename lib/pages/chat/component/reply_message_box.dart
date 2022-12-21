import 'package:flutter/material.dart';

import '../../../database/model/messages_table.dart';
import '../../../view_models/chat_vm.dart';

class ReplyCard extends StatelessWidget {

   ReplyCard({Key? key,required this.item})
      : super(key: key);

  final MessagesTable item;
  final ChatViewModel chatModel = ChatViewModel();
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 50,
                  top: 5,
                  bottom: 10,
                ),
                child: chatModel.showMessageContentView(item,false),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child:  Text(
                  item.time.toString(),
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey[600],
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
import 'package:flutter/material.dart';

import '../../../database/model/messages_table.dart';
import '../../../view_models/chat_vm.dart';

class OwnMessageCard extends StatelessWidget {
  OwnMessageCard({Key? key, required this.item}) : super(key: key);

  final MessagesTable item;

  final ChatViewModel chatModel = ChatViewModel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end ,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          seenWithTime(true, item.time.toString()),
       SizedBox(width: 5,),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              color:  Color(0xffdcf8c6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: chatModel.showMessageContentView(item),
          ),
        ],
      ),
    );
  }

  Widget seenWithTime(bool me,String time) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      if (me)
        Icon(
          Icons.done_all_outlined,
          color: Colors.grey[600],
          size: 10,
        ),
      Text(
        time,
        style: const TextStyle(
          fontSize: 10,
        ),

      ),
      SizedBox(height: 2)
    ],
  );
}

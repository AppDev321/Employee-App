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
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            item.time.toString(),
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 15),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: const Color(0xffdcf8c6),
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
}

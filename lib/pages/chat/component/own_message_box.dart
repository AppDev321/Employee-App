import 'package:flutter/material.dart';

import '../../../database/model/messages_table.dart';
import '../../../view_models/chat_vm.dart';

class OwnMessageCard extends StatelessWidget {
   OwnMessageCard({Key? key, required this.item}) : super(key: key);

  final MessagesTable item;
  final ChatViewModel chatModel = ChatViewModel();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 35,
                    right: 20,
                    top: 5,
                    bottom: 20,
                  ),
                  child: chatModel.showMessageContentView(item),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        item.time.toString(),
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        Icons.done_all,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

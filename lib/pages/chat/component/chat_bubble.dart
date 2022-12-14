import 'package:flutter/material.dart';
import 'package:hnh_flutter/database/model/messages_table.dart';
import 'package:hnh_flutter/pages/chat/component/reply_message_box.dart';
import '../whatsapp_chat_bubble_widget/bubble.dart';
import 'audio_chat_bubble.dart';
import 'own_message_box.dart';

class ChatBubble extends StatefulWidget {
  final  MessagesTable messagesTable;
  bool me, voice;
  int index;

  ChatBubble( {required this.messagesTable,required this.index,required this.me,required this.voice });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   print( widget.messagesTable.content);
  }

  @override
  Widget build(BuildContext context) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.2, vertical: 2),
        child:
        widget.me ? OwnMessageCard(message: widget.messagesTable.content!, time:widget.messagesTable.time!):
        ReplyCard(message: widget.messagesTable.content!, time:widget.messagesTable.time!)
      );

  Widget _seenWithTime(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.me)
            const Icon(
              Icons.done_all_outlined,
              color: Colors.pink,
              size: 3.4,
            ),
          Text(
            widget.messagesTable.time!,
            style:  TextStyle(fontSize: 11.8,color: Colors.black.withOpacity(0.6)),

          ),
          const SizedBox(height: .2)
        ],
      );
}
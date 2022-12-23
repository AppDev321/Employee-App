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
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 7.0),
       child:
       Row(
         crossAxisAlignment: CrossAxisAlignment.end ,
         children: <Widget>[
           Column(

             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               Container(
                 constraints: BoxConstraints(
                     maxWidth: MediaQuery.of(context).size.width * .6),
                 padding: const EdgeInsets.all(15.0),
                 decoration: const BoxDecoration(
                   color: Color(0xc9e1dfdf),
                   borderRadius: BorderRadius.only(
                     topRight: Radius.circular(25),
                     bottomLeft: Radius.circular(25),
                     bottomRight: Radius.circular(25),
                   ),
                 ),
                 child: chatModel.showMessageContentView(item),
               ),

             ],
           ),

           Text(
             item.time.toString(),
             style: TextStyle(
               fontSize: 8,
               color: Colors.grey[600],
             ),
           ),
         ],
       ),
     );
   }


}
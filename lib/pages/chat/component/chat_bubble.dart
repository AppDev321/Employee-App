import 'package:flutter/material.dart';



import '../whatsapp_chat_bubble_widget/bubble.dart';
import 'audio_chat_bubble.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(this.me, this.index, {Key? key, this.voice = false})
      : super(key: key);
  bool me, voice;
  int index;

  @override
  Widget build(BuildContext context) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.2, vertical: 2),
        child:
            Bubble(
              margin: const BubbleEdges.only(top: 2),
              color:  me ? const Color.fromARGB(255, 225, 255, 199):Colors.white,
              alignment: me ? Alignment.topRight : Alignment.topLeft,
              nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
              showNip: false,
              child:
              Wrap(
               // crossAxisAlignment: WrapCrossAlignment.end,
                textDirection: me ? TextDirection.rtl : TextDirection.ltr,
                children: [
                voice  ? const AudioBubble(filepath: 'https://sounds-mp3.com/mp3/0012660.mp3')
                    : const Text('Well, see for yourself'),
                const SizedBox(width:10),
                _seenWithTime(context),
              ],)
              ,
            )/*
            _bubble(context),
            //  AudioBubble(filepath: 'https://sounds-mp3.com/mp3/0012660.mp3',),
            const SizedBox(width: 2),
            _seenWithTime(context),*/

        ,
      );

  Widget _bubble(BuildContext context) =>
      /*voice
          ? VoiceMessage(
        audioSrc: 'https://sounds-mp3.com/mp3/0012660.mp3',
        me: index == 5 ? false : true,
      )
          :*/


      Bubble(
        margin: const BubbleEdges.only(top: 2),
        color:  me ? const Color.fromARGB(255, 225, 255, 199):Colors.white,

        alignment: me ? Alignment.topRight : Alignment.topLeft,
        nip: me ? BubbleNip.rightTop : BubbleNip.leftTop,
        showNip: false,
        child:
            Column(children: [
              voice
                  ? const AudioBubble(filepath: 'https://sounds-mp3.com/mp3/0012660.mp3')
                  :
              const Text('Well, see for yourself'),
              const SizedBox(width: 2),
              _seenWithTime(context),
            ],)
        ,
      )

  /* Container(
    constraints: const BoxConstraints(maxWidth: 100 * .7),
    padding: EdgeInsets.symmetric(
      horizontal: 4,
      vertical: voice ? 1 : 2.5,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(6),
        bottomLeft: me ? const Radius.circular(6) : const Radius.circular(2),
        bottomRight: !me ? const Radius.circular(6) : const Radius.circular(1.2),
        topRight:const Radius.circular(6),
      ),
      color: me ? Colors.pink : Colors.white,
    ),
    child: Text(
      me
          ? 'Hello, How are u?'
          : Random().nextBool()
          ? 'It\'s Rainy!'
          : Random().nextBool()
          ? 'Ok! got it.'
          : 'How was going bro ?',
      style: TextStyle(
          fontSize: 13.2, color: me ? Colors.white : Colors.black),
    ),
  )*/;

  Widget _seenWithTime(BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (me)
            const Icon(
              Icons.done_all_outlined,
              color: Colors.pink,
              size: 3.4,
            ),
          Text(
            '1:' '${index + 30}' ' PM',
            style:  TextStyle(fontSize: 11.8,color: Colors.black.withOpacity(0.6)),

          ),
          const SizedBox(height: .2)
        ],
      );
}
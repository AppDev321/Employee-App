import 'package:flutter/material.dart';

import '../provider/sound_record_notifier.dart';

/// Used this class to show counter and mic Icon
class ShowCounter extends StatelessWidget {
  final SoundRecordNotifier soundRecorderState;
  final TextStyle? counterTextStyle;
  final Color? counterBackGroundColor;

  // ignore: sort_constructors_first
  const ShowCounter({
    required this.soundRecorderState,
    Key? key,
    this.counterTextStyle,
    required this.counterBackGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: counterBackGroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(35.0),

        ),

        width: MediaQuery
            .of(context)
            .size
            .width * 0.4,
        //color: counterBackGroundColor ?? Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const SizedBox(width: 30),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(
              soundRecorderState.second.toString().padLeft(2, '0'),
          style: counterTextStyle ??
              const TextStyle(color: Colors.black),
        ),
        const SizedBox(width: 3),
         Text(" : ", style: counterTextStyle ??
            const TextStyle(color: Colors.black),
        ),
      Text(
        soundRecorderState.minute.toString().padLeft(2, '0'),
        style: counterTextStyle ??
            const TextStyle(color: Colors.black),
      ),
      ],
    ),
    const SizedBox(width: 3),
    AnimatedOpacity(
    duration: const Duration(seconds: 1),
    opacity: soundRecorderState.second % 2 == 0 ? 1 : 0,
    child: const Icon(
    Icons.mic,
    color: Colors.red,
    ),
    ),
    const SizedBox(width: 10),
    ],
    ),
    ),
    ),
    );
  }
}


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/voice_record_animation/widgets/show_counter.dart';

import '../provider/sound_record_notifier.dart';
import '../screen/social_media_recorder.dart';

// ignore: must_be_immutable
class SoundRecorderWhenLockedDesign extends StatelessWidget {
  final SoundRecordNotifier soundRecordNotifier;
  final String? cancelText;
  final Function sendRequestFunction;
  final Widget? recordIconWhenLockedRecord;
  final TextStyle? cancelTextStyle;
  final TextStyle? counterTextStyle;
  final Color recordIconWhenLockBackGroundColor;
  final Color? counterBackGroundColor;
  final Color? cancelTextBackGroundColor;
  final Widget? sendButtonIcon;
  final MicButtonActionListener hideBottomView;

  // ignore: sort_constructors_first
  const SoundRecorderWhenLockedDesign({
    Key? key,
    required this.sendButtonIcon,
    required this.soundRecordNotifier,
    required this.cancelText,
    required this.sendRequestFunction,
    required this.recordIconWhenLockedRecord,
    required this.cancelTextStyle,
    required this.counterTextStyle,
    required this.recordIconWhenLockBackGroundColor,
    required this.counterBackGroundColor,
    required this.cancelTextBackGroundColor,
    required this.hideBottomView
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: cancelTextBackGroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: InkWell(
        onTap: () {
          soundRecordNotifier.isShow = false;
          soundRecordNotifier.resetEdgePadding();
          hideBottomView(false);
        },
        child: Row(
          children: [
            InkWell(
              onTap: () async {

                soundRecordNotifier.isShow = false;
                if (soundRecordNotifier.second > 1 ||
                    soundRecordNotifier.minute > 0) {
                  String path = soundRecordNotifier.mPath;
                  await Future.delayed(const Duration(milliseconds: 500));
                  sendRequestFunction(File.fromUri(Uri(path: path)));
                }
                soundRecordNotifier.resetEdgePadding();
                hideBottomView(false);
              },
              child: Transform.scale(
                scale: 1.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(600),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    width: 50,
                    height: 50,
                    child: Container(
                      color: recordIconWhenLockBackGroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: recordIconWhenLockedRecord ??
                            sendButtonIcon ??
                            Icon(
                              Icons.send,
                              textDirection: TextDirection.ltr,
                           //   size: 28,
                              color: (soundRecordNotifier.buttonPressed)
                                  ? Colors.grey.shade200
                                  : Colors.black,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    hideBottomView(false);
                    soundRecordNotifier.isShow = false;
                    soundRecordNotifier.resetEdgePadding();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      cancelText ?? "",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: cancelTextStyle ??
                          const TextStyle(
                            color: Colors.black,
                          ),
                    ),
                  )),
            ),
            ShowCounter(
              soundRecorderState: soundRecordNotifier,
              counterTextStyle: counterTextStyle,
              counterBackGroundColor: counterBackGroundColor,
            ),
          ],
        ),
      ),
    );
  }
}

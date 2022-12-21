
import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:just_audio/just_audio.dart';

class AudioBubble extends StatefulWidget {
  const AudioBubble({Key? key, required this.filepath}) : super(key: key);

  final String filepath;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  final player = AudioPlayer();
  Duration? duration;

  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.filepath).then((value) {
      setState(() {
        duration = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Row(
        children: [
          StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return GestureDetector(
                  onTap: player.play,
                  child: const Icon(Icons.play_arrow, ),
                );
              } else if (playing != true) {
                return GestureDetector(
                  onTap: player.play,
                  child:  const Icon(Icons.play_arrow),
                );
              } else if (processingState != ProcessingState.completed) {
                return GestureDetector(

                  onTap: player.pause,
                  child: const Icon(Icons.pause),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    player.seek(Duration.zero);
                  },
                  child: const Icon(Icons.replay),
                );
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor:Colors.grey,
                        value: snapshot.data!.inMilliseconds /
                            (duration?.inMilliseconds ?? 1),
                      ),

                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            prettyDuration(
                                snapshot.data! == Duration.zero
                                    ? duration ?? Duration.zero
                                    : snapshot.data!),
                            style: const TextStyle(
                              fontSize: 10,

                            ),
                          ),
                           CustomTextWidget(text: duration!=null?prettyDuration(duration!):"00:00",size: 10)

                        ],
                      ),
                    ],
                  );
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
          ),
        ],
      );
  }

  String prettyDuration(Duration d) {
    var min = d.inMinutes < 10 ? "0${d.inMinutes}" : d.inMinutes.toString();
    var sec = d.inSeconds < 10 ? "0${d.inSeconds}" : d.inSeconds.toString();
    return "$min:$sec";
  }
}

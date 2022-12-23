import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String path;
  final ValueChanged<String> onPathGet;

  const VideoPlayerScreen({Key? key, required this.path, required this.onPathGet}) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path));


    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();



    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {

                    return Stack(
                      children:[
                        AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                        Align(
                          alignment: Alignment.center,
                          child:  ElevatedButton(
                              onPressed: () {
                                _controller.play();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  primary: Colors.lightGreen,
                                  fixedSize: const Size(80, 80)),
                              child: const Icon(Icons.play_arrow)),
                        )

                  ] );
                  } else {
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding:const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextFormField(
                    style:const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    maxLines: 6,
                    minLines: 1,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Caption....",
                        prefixIcon:const Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 27,
                        ),
                        hintStyle:const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        suffixIcon: InkWell(
                          onTap: (){
                           widget.onPathGet(widget.path);
                            Get.back();
                          },
                          child:const CircleAvatar(
                            radius: 27,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      );


  }
}
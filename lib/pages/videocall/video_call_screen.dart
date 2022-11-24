import 'dart:async';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../repository/model/request/socket_message_model.dart';
import '../../repository/model/response/get_dashboard.dart';
import '../../utils/controller.dart';
import '../../websocket/audio_video_call.dart';
import '../../widget/custom_text_widget.dart';

class VideoCallScreen extends StatefulWidget {
  final String targetUserID;

  final bool isIncommingCall;
  final SocketMessageModel? socketMessageModel;

  VideoCallScreen({
    Key? key,
    required this.targetUserID,
    this.isIncommingCall = false,
    this.socketMessageModel,
  }) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late User userObject;
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  var targetUserId = "";
  bool isCalling = false;
  SocketMessageModel? socketMessageModel;
  bool isIncommingCall = false;

  bool isMicUnmute = true;
  bool isVideoEnable = true;
  bool isRemoteUserOnline = false;
  final List _remoteRenderers = [];
  String callingStatus = "Calling";

  late AudioVideoCall audioVideoCall;

  void endCall(bool isUserClosedCall) async {
    await _remoteVideoRenderer.dispose();
    await _localVideoRenderer.dispose();
    audioVideoCall.endCall(isUserClosedCall);

    Navigator.of(context).pop(true);
  }

  void switchCamera() {
    audioVideoCall.switchCamera();
  }

  void videoCallAction() {
    setState(() {
      isVideoEnable = !isVideoEnable;
      audioVideoCall.videoCallAction(isVideoEnable);
    });
  }

  void micAction() {
    setState(() {
      isMicUnmute = !isMicUnmute;
      audioVideoCall.micAction(isMicUnmute);
    });
  }

  void initRenderers() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  loadPreferenceUserData() async {
    User userData = User.fromJson(await Controller()
        .getObjectPreference(Controller.PREF_KEY_USER_OBJECT));

    setState(() {
      userObject = userData;
      targetUserId = widget.targetUserID;
      isIncommingCall = widget.isIncommingCall;
      socketMessageModel = widget.socketMessageModel;

      audioVideoCall = AudioVideoCall();
      audioVideoCall.targetUserId = targetUserId;
      audioVideoCall.currentUserId = userObject.id.toString();

      audioVideoCall.onLocalStream = ((stream) {
        setState(() {
          _localVideoRenderer.srcObject = stream;
        });

      });

      audioVideoCall.onAddRemoteStream = ((stream) {

        setState(() {
          _remoteVideoRenderer.srcObject = stream;
        });
      });
      audioVideoCall.initializeState();
      audioVideoCall.peerConnectionStatus=()
      {

        if (isIncommingCall) {
          if (socketMessageModel != null) {
            if (socketMessageModel!.type
                .toString()
                .contains(SocketMessageType.OfferReceived.displayTitle)) {
              audioVideoCall .setRemoteDescription(jsonEncode(socketMessageModel?.data));
              audioVideoCall.answerCall(socketMessageModel!);

              setState(() {
                isRemoteUserOnline = true;
              });

            }
          }
        }
        else
          {
            audioVideoCall.checkUserIsOnline();
          }
      };


    });
  }

  @override
  void initState() {
    loadPreferenceUserData();

    initRenderers();

    handleSocketBroadCasting();




    super.initState();
  }

  void handleSocketBroadCasting() {



    //Handle web socket message
    FBroadcast.instance().register(Controller().socketMessageBroadCast,
        (socketMessage, callback) {
      var message = socketMessage as SocketMessageModel;
      print("Message Received Socket: ${message.toJson()}");
      var msgType = message.type.toString();

      if (msgType == SocketMessageType.CallResponse.displayTitle) {
        if (message.data == true) {
          setState(() {
            callingStatus = "Ringing";
          });

          audioVideoCall.createOffer();
        } else {
          setState(() {
            callingStatus = "Calling";
          });
        }
      } else if (msgType == SocketMessageType.OfferReceived.displayTitle) {
        /*audioVideoCall.setRemoteDescription(jsonEncode(message.data));
        Controller().showConfirmationMsgDialog(
            context, message.callerName.toString(), "Incoming Call", "Answer",
            (value) {
          if (value) {
            audioVideoCall.answerCall(message);
            setState(() {
              isRemoteUserOnline = true;
            });
          }
        });*/
      } else if (msgType == SocketMessageType.AnswerReceived.displayTitle) {
        audioVideoCall.setRemoteDescription(jsonEncode(message.data));
        audioVideoCall.startTimer();
        setState(() {
          isRemoteUserOnline = true;
        });
      } else if (msgType == SocketMessageType.ICECandidate.displayTitle) {
        audioVideoCall.addCandidate(jsonEncode(message.data));
      } else if (msgType == SocketMessageType.CallClosed.displayTitle) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message.data),
        ));
        endCall(false);
      }
    });
  }

  @override
  void dispose() async {
    await _remoteVideoRenderer.dispose();
    await _localVideoRenderer.dispose();
    audioVideoCall.disposeAudioVideoCall();
    super.dispose();
  }

  Widget videoCallBottomButtonWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        /*  Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                audioVideoCall.checkUserIsOnline();
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),*/
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                micAction();
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                isMicUnmute == true ? Icons.mic : Icons.mic_off,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                endCall(true);
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.redAccent,
              padding: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.call_end,
                color: Colors.white,
                size: 35.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                videoCallAction();
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                isVideoEnable == true ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                switchCamera();
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              child: const Icon(
                Icons.switch_camera,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> onBackButtonPress() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to end this call?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  endCall(true);
                  //Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackButtonPress,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Video Call"),
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            return Stack(children: <Widget>[
              _remoteRenderers.isNotEmpty
                  ? Row(
                      children: [
                        ..._remoteRenderers.map((remoteRenderer) {
                          return SizedBox(
                              width: 160,
                              height: 120,
                              child: RTCVideoView(remoteRenderer));
                        }).toList(),
                      ],
                    )
                  : Center(),
              Positioned(
                  child: isRemoteUserOnline
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration:
                              const BoxDecoration(color: Colors.black54),
                          child: RTCVideoView(_remoteVideoRenderer),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              CircularProgressIndicator(strokeWidth: 3),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: CustomTextWidget(text: callingStatus))
                            ])),
              isVideoEnable
                  ? Positioned(
                      bottom: 150.0,
                      right: 20.0,
                      child: Container(
                        width: 105.0,
                        height: 140.0,
                        decoration: const BoxDecoration(color: Colors.black54),
                        child: RTCVideoView(_localVideoRenderer),
                      ),
                    )
                  : const Center(),
              videoCallBottomButtonWidget()
            ]);
          })),
    );
  }
}

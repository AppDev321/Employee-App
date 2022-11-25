import 'dart:async';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_incoming_call/flutter_incoming_call.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/view_models/dashbboard_vm.dart';

import '../../repository/model/request/socket_message_model.dart';
import '../../repository/model/response/get_dashboard.dart';
import '../../utils/controller.dart';
import '../../utils/size_config.dart';
import '../../websocket/audio_video_call.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/dial_button.dart';
import '../../widget/dial_user_pic.dart';
import '../../widget/rounded_button.dart';


class AudioCallScreen extends StatefulWidget {
  final String tragetID;

  AudioCallScreen({Key? key, required this.tragetID}) : super(key: key);

  @override
  _AudioCallScreenState createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  late User userObject;
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  var targetUserId = "";
  bool isCalling = false;

  bool isMicUnmute = true;
  bool isSpeakerEnabled = true;
  bool isRemoteUserOnline = false;
  String callTime = "Calling...";


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
      isSpeakerEnabled = !isSpeakerEnabled;
      audioVideoCall.videoCallAction(isSpeakerEnabled);
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

      audioVideoCall = AudioVideoCall();
      audioVideoCall.targetUserId = targetUserId;
      audioVideoCall.currentUserId = userObject.id.toString();
      audioVideoCall.isVideoCall = true;

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

      audioVideoCall.timerCount= ((timer){
        setState(() {
          callTime = timer;
        });
      });
      audioVideoCall.initializeState();
    });
  }

  @override
  void initState() {
    loadPreferenceUserData();
    targetUserId = widget.tragetID;
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

      if(msgType == SocketMessageType.CallResponse.displayTitle)
        {
          if(message.data == true)
            {
              setState(() {
                callTime = "Ringing";
              });

              audioVideoCall.createOffer();
            }
          else
            {
              setState(() {
                callTime = "Calling";
              });
            }

        }
      else if (msgType == SocketMessageType.OfferReceived.displayTitle) {
        audioVideoCall.setRemoteDescription(jsonEncode(message.data));
        Controller().showConfirmationMsgDialog(
            context, message.callerName.toString(), "Incoming Call", "Answer",
            (value) {
          if (value) {

            audioVideoCall.answerCall(message);
            setState(() {
              isRemoteUserOnline = true;
            });
            audioVideoCall.startTimmer();
           audioVideoCall.speakerPhoneAction(false);
          }
        });

      /*  DashBoardViewModel model = DashBoardViewModel();
        model.handleSocketMessage(SocketMessageType.OfferReceived, message);
        */

      } else if (msgType == SocketMessageType.AnswerReceived.displayTitle) {
        audioVideoCall.setRemoteDescription(jsonEncode(message.data));
        audioVideoCall.startTimmer();
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
                  Navigator.of(context).pop(false);
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
    SizeConfig().init(context);
    var color = Get.isDarkMode ? Colors.white : Colors.black;
    return WillPopScope(
        onWillPop: onBackButtonPress,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Voice Call"),
            ),
            body:  Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                        text: "Admin AFJ",
                        color: color,
                        size: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      Text(
                        callTime,
                        style: TextStyle(color: color),
                      ),
                      const VerticalSpacing(),
                      const DialUserPic(image: "assets/images/anne.jpeg"),
                      const Spacer(),

                      voiceCallButtonWidget(),

                      Expanded(
                        flex: 1,
                        child: RawMaterialButton(
                          onPressed: () {
                            endCall(true);
                          },
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.red,
                          padding: const EdgeInsets.all(15.0),
                          child: const Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
  Widget voiceCallButtonWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                // audioVideoCall.checkUserIsOnline();
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
          ),
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
setState(() {
  isSpeakerEnabled = !isSpeakerEnabled;
});
              },
              shape: const CircleBorder(),
              elevation: 2.0,
              fillColor: Colors.black,
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                isSpeakerEnabled == true ? Icons.volume_up : Icons.volume_off,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),

        ],
      ),
    );
  }

}

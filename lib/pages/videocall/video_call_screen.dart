import 'dart:async';
import 'dart:convert';


import 'package:fbroadcast/fbroadcast.dart';
import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hnh_flutter/view_models/chat_vm.dart';
import 'package:wakelock/wakelock.dart';


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

class _VideoCallScreenState extends State<VideoCallScreen>  {

  late User userObject;
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  var targetUserId = "";
  bool isCalling = false;
  SocketMessageModel? socketMessageModel;
  bool isIncomingCall = false;

  bool isMicUnmute = true;
  bool isVideoEnable = true;
  bool isRemoteUserOnline = false;
  final List _remoteRenderers = [];
  String callingStatus = "Calling";

  late AudioVideoCall audioVideoCall;

  late ChatViewModel chatViewModel;

  void endCall(bool isUserClosedCall, {bool isFromDialog = false}) async {
    Wakelock.disable();

    if(socketMessageModel != null) {
      chatViewModel.insertCallEndDetailInDB(socketMessageModel!, targetUserId);
    }
    await _remoteVideoRenderer.dispose();
    await _localVideoRenderer.dispose();
    audioVideoCall.endCall(isUserClosedCall);
    if (!isFromDialog) {
      Navigator.of(context).pop(true);
    }
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
      isIncomingCall = widget.isIncommingCall;
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
        Controller().printLogs("remote stream coming==>>");
        setState(() {
          _remoteVideoRenderer.srcObject = stream;
        });
      });
      audioVideoCall.initializeState();
      audioVideoCall.peerConnectionStatus = () {
        if (isIncomingCall) {
          if (socketMessageModel != null) {


            if (socketMessageModel!.type.toString().contains(SocketMessageType.IncomingCall.displayTitle)) {
                audioVideoCall.joinCall(socketMessageModel!);
                setState(() {
                  callingStatus = "Connecting...";
                });
            }

          }
        } else {
          audioVideoCall.checkUserIsOnline();
        }
      };

      audioVideoCall.connectionState = (connectionState){
        if (connectionState == RTCIceConnectionState.RTCIceConnectionStateConnected) {
          setState(() {
            callingStatus = "Connected";
            isRemoteUserOnline = true;
          });
        }

       else if (connectionState == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
                connectionState == RTCIceConnectionState.RTCIceConnectionStateFailed)
        {
          setState(() {
            callingStatus = "Reconnecting";
              isRemoteUserOnline = false;
          });
        }
      };

    });
  }

  @override
  void initState() {
    Wakelock.enable();
    loadPreferenceUserData();
    initRenderers();
    handleSocketBroadCasting();
    chatViewModel = ChatViewModel();
    super.initState();
  }

  void handleSocketBroadCasting() {
    //Handle web socket message
    FBroadcast.instance().register(Controller().socketMessageBroadCast,
        (socketMessage, callback) {
      var message = socketMessage as SocketMessageModel;
      Controller().printLogs("Message Received Socket -- video call: ${message.toJson()}");
      var msgType = message.type.toString();

      if (msgType == SocketMessageType.CallResponse.displayTitle) {
        dynamic jsonData =  jsonEncode(message.data);
        var body = jsonDecode(jsonData);

        UserCallingStatus userCallingStatus = UserCallingStatus.fromJson(body);

        if (userCallingStatus.isOnline== true) {
          if(userCallingStatus.isBusy == true)
            {
              setState(() {
                callingStatus = "User is busy";
              });

            }
          else {
            setState(() {
              callingStatus = "Ringing";
            });

            audioVideoCall.createOffer();
          }


        } else {
          setState(() {
            callingStatus = "Calling";
          });
        }
        chatViewModel.insertCallDetailInDB(message);

      } else if (msgType == SocketMessageType.OfferReceived.displayTitle) {
        audioVideoCall.setRemoteDescription(jsonEncode(message.data));


        audioVideoCall.answerCall(message);
        setState(() {
          isRemoteUserOnline = true;
        });

      } else if (msgType == SocketMessageType.AnswerReceived.displayTitle) {
        audioVideoCall.setRemoteDescription(jsonEncode(message.data));
        audioVideoCall.offerConnectionID = message.offerConnectionId as String;
        audioVideoCall.startTimer();
        setState(() {
          isRemoteUserOnline = true;
        });
      } else if (msgType == SocketMessageType.ICECandidate.displayTitle) {
        //Just save data for database in call history
        socketMessageModel = message;
        // ********************************

        audioVideoCall.addCandidate(jsonEncode(message.data));
      } else if (msgType == SocketMessageType.CallClosed.displayTitle) {
        endCall(false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message.data),
        ));

      }
    },context: this);
  }

  @override
  void dispose() async {

    FBroadcast.instance().unregister(this);
    audioVideoCall.disposeAudioVideoCall();
    //await _remoteVideoRenderer.dispose();

   // await _localVideoRenderer.dispose();


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
            Expanded(
            flex: 1,
            child: RawMaterialButton(
              onPressed: () {
                //audioVideoCall.checkUserIsOnline();
               // audioVideoCall.sendIceCandidatesToSocket();
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

                  Navigator.of(context).pop(true);
                  endCall(true, isFromDialog: true);
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
            return
        showVideoPreviewScreen(true);




          })),
    );
  }


  Widget showVideoPreviewScreen(bool isPipMode)
  {
    return isPipMode
    ?Stack(children: <Widget>[

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
    ]) :
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
        : Center();
  }
}

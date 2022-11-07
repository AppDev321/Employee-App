import 'dart:collection';
import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'package:hnh_flutter/websocket/service/socket_service.dart';
import 'package:sdp_transform/sdp_transform.dart';

import '../../repository/model/request/socket_message_model.dart';
import '../../repository/model/response/get_dashboard.dart';
import '../../utils/controller.dart';

class VideoCallScreen extends StatefulWidget {
  final String tragetID;

  VideoCallScreen({Key? key, required this.tragetID}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late User userObject;
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  bool _offer = false;
  var targetUserId = "";
  bool isCalling = false;
  RTCPeerConnection? _peerConnection;
  late MediaStream _localStream;
  SocketService socketService = SocketService();
  bool isMicUnmute = true;
  bool isVideoEnable = true;
  bool isRemoteUserOnline = false;

  final Map<String, dynamic> offerSdpConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [
      {"DtlsSrtpKeyAgreement": true},
      {"RtpDataChannels": true},
    ],
  };

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:iphone-stun.strato-iphone.de:3478"},
        {"url": "stun:openrelay.metered.ca:80"},
        {"url": "stun:openrelay.metered.ca:443"},
        {"url": "stun:openrelay.metered.ca:443"},
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        HashMap<String, dynamic> candidate = HashMap.of({
          'sdpCandidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMLineIndex': e.sdpMlineIndex,
        });
        var iceCandidate = SocketMessageModel(
            type: SocketMessageType.SendIceCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: userObject.id.toString(),
            data: candidate);
        socketService.sendMessageToWebSocket(iceCandidate);
      }
    };

    pc.onIceConnectionState = (e) {
      print("ice exception: $e");
    };

    pc.onAddStream = (stream) {

      setState(() {
        _remoteVideoRenderer.srcObject = stream;
      });
    };

    return pc;
  }

  void createOffer() async {
    RTCSessionDescription description = await _peerConnection!
       .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
 //  .createOffer(offerSdpConstraints);

    _offer = true;
    _peerConnection!.setLocalDescription(description);

    var sdpSession = parse(description.sdp.toString());
    var type = parse(description.type.toString());

    HashMap<String, dynamic> offerData =
        HashMap.of({"type": type, "sdp": sdpSession});

    var createOffer = SocketMessageModel(
        type: SocketMessageType.CreateOffer.displayTitle,
        sendTo: targetUserId,
        sendFrom: userObject.id.toString(),
        data: offerData);

    socketService.sendMessageToWebSocket(createOffer);
  }

  void answerCall(SocketMessageModel answer) async {
    RTCSessionDescription description = await _peerConnection!
       .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
    //    .createAnswer(offerSdpConstraints);
    _peerConnection!.setLocalDescription(description);

    var sdpSession = parse(description.sdp!); //parse(description.sdp!);
    var type = parse(description.type!); //parse(description.type!);
    HashMap<String, dynamic> offerData =
        HashMap.of({"type": type, "sdp": sdpSession});
    var answerCall = SocketMessageModel(
        type: SocketMessageType.AnswerCall.displayTitle,
        sendTo: targetUserId,
        sendFrom: userObject.id.toString(),
        data: offerData);

    socketService.sendMessageToWebSocket(answerCall);
  }

  void setRemoteDescription(String jsonString) async {
    dynamic session = await jsonDecode(jsonString);

    String sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

    await _peerConnection!.setRemoteDescription(description);

  }

  void addCandidate(String jsonString) async {
    dynamic session = await jsonDecode(jsonString);

    dynamic candidate = RTCIceCandidate(
        session['sdpCandidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _peerConnection!.addCandidate(candidate);
  }

  void endCall(bool isUserClosedCall) async{
    if (_localStream != null) {
      await _localStream.dispose();
      await _remoteVideoRenderer.dispose();
      await _localVideoRenderer.dispose();
    }

    if (_peerConnection != null) {
      _peerConnection?.close();
    }

    if(isUserClosedCall)
      {
        var endCall = SocketMessageModel(
            type: SocketMessageType.CallEnd.displayTitle,
            sendTo: targetUserId,
            sendFrom: userObject.id.toString(),
            data: 0);

        socketService.sendMessageToWebSocket(endCall);
      }

    Navigator.pop(context);
  }

  void switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

  void videoCallAction() {
    if (_localStream != null) {
      setState(() {
        isVideoEnable = !isVideoEnable;
        _localStream.getVideoTracks()[0].enabled = isVideoEnable;
      });
    }
  }

  void micAction() {
    if (_localStream != null) {
      setState(() {
        isMicUnmute = !isMicUnmute;
        print("Mic status = $isMicUnmute");
        _localStream.getAudioTracks()[0].enabled = isMicUnmute;
      });
    }
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
    });
  }

  @override
  void initState() {
    targetUserId = widget.tragetID;

    loadPreferenceUserData();
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;

    });

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

      if (msgType == SocketMessageType.OfferReceived.displayTitle) {

        setRemoteDescription(jsonEncode(message.data));
        Controller().showConfirmationMsgDialog(
            context, message.callerName.toString(), "Incoming Call", "Answer",
            (value) {
          if (value) {

            answerCall(message);
            setState(() {
              isRemoteUserOnline =true;
            });
          }
        });
      } else if (msgType == SocketMessageType.AnswerReceived.displayTitle) {
        setRemoteDescription(jsonEncode(message.data));
        setState(() {
          isRemoteUserOnline =true;
        });

      } else if (msgType == SocketMessageType.ICECandidate.displayTitle) {
        addCandidate(jsonEncode(message.data));
      }
      else if (msgType == SocketMessageType.CallClosed.displayTitle)
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message.data),
          ));
          endCall(false);
        }
    });
  }

  @override
  void dispose() async {
    _localStream.dispose();
    await _remoteVideoRenderer.dispose();
    await _localVideoRenderer.dispose();
    if (_peerConnection != null) {
      _peerConnection?.close();
    }

    
    
    super.dispose();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
      }
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    setState(() {
      _localVideoRenderer.srcObject = stream;
    });
    return stream;
  }

  Widget videoCallBottomButtonWidget() {
    return  Container(
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
                    createOffer();
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
      builder: (context) =>  AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to end this call?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:const  Text('No'),
          ),
          TextButton(
            onPressed: () {
              endCall(true);
             // Navigator.of(context).pop(true);
              },
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
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
              Positioned(
                  child: isRemoteUserOnline
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration:
                              const BoxDecoration(color: Colors.black54),
                          child: RTCVideoView(_remoteVideoRenderer),
                        )
                      :const Center(child: CircularProgressIndicator(strokeWidth: 3))),
              isVideoEnable
                  ? Positioned(
                      bottom: 150.0,
                      right: 20.0,
                      child: Container(
                        width:
                          105.0,
                        height:
                             140.0 ,
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

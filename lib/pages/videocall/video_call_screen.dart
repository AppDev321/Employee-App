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
      print('addStream: ' + stream.id);
      setState(() {
        _remoteVideoRenderer.srcObject = stream;
      });
    };

    return pc;
  }

  void createOffer() async {
    RTCSessionDescription description = await _peerConnection!
        .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
    // await _peerConnection!.createOffer(offerSdpConstraints);

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
 /*   var sdp = jsonEncode(answer.data);
    dynamic session = jsonDecode(sdp);
    sdp = write(session, null);

    RTCSessionDescription description =
        RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');*/


    RTCSessionDescription description = await _peerConnection!
        .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
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
    print("remote description issue here ... ");
  }

  void addCandidate(String jsonString) async {
    dynamic session = await jsonDecode(jsonString);

    dynamic candidate = RTCIceCandidate(
        session['sdpCandidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _peerConnection!.addCandidate(candidate);
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
    if (targetUserId == "11") {
      isCalling = true;
    }

    loadPreferenceUserData();
    initRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
      if (isCalling) {
        createOffer();
      }

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
          }


        });
      } else if (msgType == SocketMessageType.AnswerReceived.displayTitle) {
        setRemoteDescription(jsonEncode(message.data));
      }
      else if (msgType == SocketMessageType.ICECandidate.displayTitle) {
        addCandidate(jsonEncode(message.data));
      }
    });
  }

  @override
  void dispose() async {
    _localStream.dispose();
    await _remoteVideoRenderer.dispose();
    await _localVideoRenderer.dispose();
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

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Chat"),
      ),
      body: Stack(
        children: [
          Positioned(

              child: RTCVideoView(_localVideoRenderer,mirror: true,))
        ],
      ),
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video Call"),
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return Container(
            child: Stack(children: <Widget>[
              Positioned(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Colors.black54),
                child: RTCVideoView(_remoteVideoRenderer),
              )),
              Positioned(
                left: 20.0,
                top: 20.0,
                child: Container(
                  width: orientation == Orientation.portrait ? 90.0 : 120.0,
                  height: orientation == Orientation.portrait ? 120.0 : 90.0,
                  decoration: const BoxDecoration(color: Colors.black54),
                  child: RTCVideoView(_localVideoRenderer),
                ),
              ),
            ]),
          );
        }));
  }
}

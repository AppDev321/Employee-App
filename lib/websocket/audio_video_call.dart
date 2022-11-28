import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_dtmf/dtmf.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hnh_flutter/websocket/service/socket_service.dart';
//import 'package:sdp_transform/sdp_transform.dart';

import '../repository/model/request/socket_message_model.dart';
import '../utils/controller.dart';


typedef StreamStateCallback = void Function(MediaStream stream);
typedef SreamTimerCallback = void Function(String timer);
typedef PeerConnectionCreatedSuccessfully = void Function();



class AudioVideoCall{
  late StreamStateCallback onLocalStream;
  late StreamStateCallback onAddRemoteStream;
  late PeerConnectionCreatedSuccessfully peerConnectionStatus;
  bool isVideoCall = true;


  late SreamTimerCallback timerCount;

  final List _remoteRenderers = [];
  var targetUserId = "";
  var currentUserId = "";
  Timer? _timmerInstance ;
  int _start = 0;
  String _timmer = '';
  late MediaStream _localStream;


  RTCPeerConnection? _peerConnection;

  bool _offer = false;
  SocketService socketService = SocketService();


  final Map<String, dynamic> offerVideoCallConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,
      "OfferToReceiveVideo": true,
    },
    "optional": [
      {"DtlsSrtpKeyAgreement": true},
      {"RtpDataChannels": true},
    ],
  };


  final Map<String, dynamic> offerAudioConstraints = {
    "mandatory": {
      "OfferToReceiveAudio": true,

    },
    "optional": [
      {"DtlsSrtpKeyAgreement": true},
      {"RtpDataChannels": true},
    ],
  };


  void startTimer() {
    var oneSec = const Duration(seconds: 1);
    _timmerInstance = Timer.periodic(
        oneSec,
            (Timer timer){
          if (_start < 0) {
            _timmerInstance?.cancel();
          } else {
            _start = _start + 1;
            _timmer = getTimerTime(_start);
         timerCount(_timmer);
          }
        });
  }

  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = '0$minutes';
    } else {
      sMinute = minutes.toString();
    }

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = '0$seconds';
    } else {
      sSeconds = seconds.toString();
    }

    return '$sMinute:$sSeconds';
  }

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

    _localStream = await getUserMedia();

    RTCPeerConnection pc =
    await createPeerConnection(configuration, isVideoCall? offerVideoCallConstraints: offerAudioConstraints);

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        HashMap<String, dynamic> candidate = HashMap.of({
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMLineIndex': e.sdpMlineIndex,
        });
        var iceCandidate = SocketMessageModel(
            type: SocketMessageType.SendIceCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: currentUserId,
            data: candidate);
        socketService.sendMessageToWebSocket(iceCandidate);
      }
    };

    pc.onIceConnectionState = (e) {
      print("ice exception: $e");
    };

    pc.onAddStream = (stream) {
      onAddRemoteStream(stream);
    /*  setState(() {
        _remoteVideoRenderer.srcObject = stream;
      });*/
    };


    /*  pc.onTrack = (event) async {
      if (event.track.kind == 'video' && event.streams.isNotEmpty) {
        var renderer = RTCVideoRenderer();
        await renderer.initialize();
        renderer.srcObject = event.streams[0];

        setState(() { _remoteRenderers.add(renderer); });
      }
    };

    pc.onRemoveStream = (stream) {
      var rendererToRemove;
      var newRenderList = [];

      // Filter existing renderers for the stream that has been stopped
      _remoteRenderers.forEach((r) {
        if (r.srcObject.id == stream.id) {
          rendererToRemove = r;
        } else {
          newRenderList.add(r);
        }
      });

      // Set the new renderer list
      setState(() { _remoteRenderers = newRenderList; });

      // Dispose the renderer we are done with
      if (rendererToRemove != null) {
        rendererToRemove.dispose();
      }
    };*/

    return pc;
  }
  getUserMedia() async {
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
    onLocalStream(stream);
 /*   setState(() {
      _localVideoRenderer.srcObject = stream;
    });*/
    return stream;
  }

  void initializeState() {
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
      peerConnectionStatus();
    });
  }


  void disposeAudioVideoCall() async {
    _localStream.dispose();

    if (_peerConnection != null) {
      _peerConnection?.close();
    }
    if(_timmerInstance!= null) {
      _timmerInstance?.cancel();
    }
  }
  void checkUserIsOnline() async {

      var createOffer = SocketMessageModel(
          type: SocketMessageType.StartCall.displayTitle,
          sendTo: targetUserId,
          sendFrom: currentUserId,
          data: 0);
      socketService.sendMessageToWebSocket(createOffer);
  }

  void createOffer() async {

    try {
      RTCSessionDescription description = await _peerConnection!
      //  .createOffer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
          .createOffer(
          isVideoCall ? offerVideoCallConstraints : offerAudioConstraints);

      _offer = true;
      _peerConnection!.setLocalDescription(description);

      //var sdpSession = parse(description.sdp.toString());
      //var type = parse(description.type.toString());

      HashMap<String, dynamic> offerData =
      HashMap.of({"type": "offer", "sdp": description.sdp.toString()});

      var createOffer = SocketMessageModel(
          type: SocketMessageType.CreateOffer.displayTitle,
          sendTo: targetUserId,
          sendFrom: currentUserId,
          data: offerData);

      socketService.sendMessageToWebSocket(createOffer);
    }
    catch(exception )
    {
      print("Offer create exception == $exception");
      if(exception.toString().contains("Offer called when PeerConnection is closed")) {
        initializeState();
        createOffer();
      }
    }
  }

  void answerCall(SocketMessageModel answer) async {
    RTCSessionDescription description = await _peerConnection!
    // .createAnswer({'offerToReceiveVideo': 1, 'offerToReceiveAudio': 1});
        .createAnswer(isVideoCall? offerVideoCallConstraints: offerAudioConstraints);
    _peerConnection!.setLocalDescription(description);

    //var sdpSession = parse(description.sdp!); //parse(description.sdp!);
    //var type = parse(description.type!); //parse(description.type!);
    HashMap<String, dynamic> offerData =
    HashMap.of({"type": "answer", "sdp": description.sdp.toString()});
    var answerCall = SocketMessageModel(
        type: SocketMessageType.AnswerCall.displayTitle,
        sendTo: targetUserId,
        sendFrom: currentUserId,
        data: offerData);

    socketService.sendMessageToWebSocket(answerCall);
  }

  void setRemoteDescription(String jsonString) async {
    final body = json.decode(jsonString);

   // dynamic session = await jsonDecode(jsonString);


    //String sdp = write(session, null);

    RTCSessionDescription description =
    RTCSessionDescription(body['sdp'], _offer ? 'answer' : 'offer');

    await _peerConnection!.setRemoteDescription(description);
  }

  void addCandidate(String jsonString) async {
    dynamic session = await jsonDecode(jsonString);

    dynamic candidate = RTCIceCandidate(
        session['candidate'], session['sdpMid'], session['sdpMLineIndex']);
    await _peerConnection!.addCandidate(candidate);

  }


  void endCall(bool isUserClosedCall) async{
    await _localStream.dispose();
    if(_timmerInstance != null)
    {
      _timmerInstance?.cancel();
    }

    if (_peerConnection != null) {
      _peerConnection?.close();
    }
    if(isUserClosedCall)
    {
      var endCall = SocketMessageModel(
          type: SocketMessageType.CallEnd.displayTitle,
          sendTo: targetUserId,
          sendFrom: currentUserId,
          data: 0);
      socketService.sendMessageToWebSocket(endCall);
    }
  }

  void switchCamera() {
    _localStream.getVideoTracks()[0].switchCamera();
  }

  void videoCallAction(bool isVideoEnable) {
      _localStream.getVideoTracks()[0].enabled = isVideoEnable;
  }

  void micAction(bool isMicUnmute) {
    _localStream.getAudioTracks()[0].enabled = isMicUnmute;
  }

  void speakerPhoneAction(bool isSpeakerPhone) {
    _localStream.getAudioTracks()[0].enableSpeakerphone(isSpeakerPhone);

  }

  void createDTMFTone() async
  {
    /*RTCRtpSender? m_audioSender = null;
    var listSender = await _peerConnection?.getSenders() as List<RTCRtpSender>;
    for (var sender in listSender) {

        if (sender.track?.kind.toString()=="audio") {
        m_audioSender = sender;
        }
  }

    RTCDTMFSender dtmfSender = m_audioSender?.dtmfSender as RTCDTMFSender;
    dtmfSender.insertDTMF(, 50, 50);*/

  }
}
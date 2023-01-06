import "dart:async";
import "dart:collection";
import "dart:convert";

import "package:crypto/crypto.dart";
import "package:flutter_webrtc/flutter_webrtc.dart";
import "package:hnh_flutter/websocket/service/socket_service.dart";
import "package:just_audio/just_audio.dart";

import "../repository/model/request/socket_message_model.dart";
import "../utils/controller.dart";

typedef StreamStateCallback = void Function(MediaStream stream);
typedef SreamTimerCallback = void Function(String timer);
typedef PeerConnectionCreatedSuccessfully = void Function();

class AudioVideoCall {
  late StreamStateCallback onLocalStream;
  late StreamStateCallback onAddRemoteStream;
  late PeerConnectionCreatedSuccessfully peerConnectionStatus;
  bool isVideoCall = true;

  late SreamTimerCallback timerCount;

  final List _remoteRenderers = [];
  var targetUserId = "";
  var currentUserId = "";
  Timer? _timmerInstance;

  int _start = 0;
  String _timmer = '';
  late MediaStream _localStream;

  RTCPeerConnection? _peerConnection;

  bool _offer = false;
  SocketService socketService = SocketService();
  AudioPlayer? player;


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


  var secret =  "8f60119eb0b51b511bf4b0fb7838e36c";
 //"d130e4a5701c5f287a1506c974544631a774cc3370325aa6570e56e95bd8cfe6";

  var uuID = ((DateTime.now().millisecond/1000) + (12 * 3600)).toString();

  dynamic generateSHA1MAC( String value,  String secretKEy)
  {
    var key = utf8.encode(secretKEy);
    var bytes = utf8.encode(value);
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

  return digest.bytes.toString();
}

void startTimer() {
    var oneSec = const Duration(seconds: 1);
    _timmerInstance = Timer.periodic(oneSec, (Timer timer) {
      if (_start < 0) {
        _timmerInstance?.cancel();
      } else {
        _start = _start + 1;
        _timmer = getTimerTime(_start);
      //  timerCount(_timmer);
      }
    });
  }

  String getTimerTime(int start) {
    int minutes = (start ~/ 60);
    String sMinute = '';
    if (minutes.toString().length == 1) {
      sMinute = "0$minutes";
    } else {
      sMinute = minutes.toString();
    }

    int seconds = (start % 60);
    String sSeconds = '';
    if (seconds.toString().length == 1) {
      sSeconds = "0$seconds";
    } else {
      sSeconds = seconds.toString();
    }

    return "$sMinute:$sSeconds";
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers":
      [
          /*  {
           "url": "stun:vmi808920.contaboserver.net:3479"
          // "url": "stun:gotcha.im:8000"
            },*/

        {
          "url": "stun:relay.metered.ca:80",
        },
        {
          "url": "turn:relay.metered.ca:80",
          "username": "b4d93dc44330adba2c73192a",
          "credential": "9IdESWTGHDtWHGkg",
        },
        {
          "url": "turn:relay.metered.ca:443",
          "username": "b4d93dc44330adba2c73192a",
          "credential": "9IdESWTGHDtWHGkg",
        },
        {
          "url": "turn:relay.metered.ca:443?transport=tcp",
          "username": "b4d93dc44330adba2c73192a",
          "credential": "9IdESWTGHDtWHGkg",
        },


      ],
      //"iceTransportPolicy": "relay",
    };

    _localStream = await getUserMedia();



    RTCPeerConnection pc = await createPeerConnection(configuration,
        isVideoCall ? offerVideoCallConstraints : offerAudioConstraints);
    print("configuration == ${configuration["iceServers"]}" );

    pc.onAddStream = (stream) {
      stopCallerTone();
      onAddRemoteStream(stream);
      /*  setState(() {
        _remoteVideoRenderer.srcObject = stream;
      });*/
    };

    pc.addStream(_localStream);

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        HashMap<String, dynamic> candidate = HashMap.of({
          "candidate": e.candidate.toString(),
          "sdpMid": e.sdpMid.toString(),
          "sdpMLineIndex": e.sdpMlineIndex,
        });
        var iceCandidate = SocketMessageModel(
            type: SocketMessageType.SendIceCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: currentUserId,
            data: candidate);

        socketService.sendMessageToWebSocket(iceCandidate);

        //****** Send Candidate as per backend handle logic *********
        var sendCandidate = SocketMessageModel(
            type: SocketMessageType.SendCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: currentUserId,
            data: candidate);
            socketService.sendMessageToWebSocket(sendCandidate);
        //********************************************


      }
    };

    pc.onIceGatheringState = (RTCIceGatheringState state) {
      print("ICE gathering state changed: $state");
    };

    pc.onConnectionState = (RTCPeerConnectionState state) {
      print("Connection state change: $state");

    };

    pc.onSignalingState = (RTCSignalingState state) {
      print("Signaling state change: $state");
    };


    pc.onIceConnectionState = (state) {
      print("ICE Connection state changed: $state");

      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        /* possibly reconfigure the connection in some way here */
        /* then request ICE restart */

      }
    };



    /*  pc.onTrack = (event) async {
      if (event.track.kind == "video" && event.streams.isNotEmpty) {
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
      "audio": true,
      "video": {
        "mandatory": {
          "minWidth":
              "640", // Provide your own width, height and frame rate here
          "minHeight": "480",
          "minFrameRate": "30",
        },
        "facingMode": "user",
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
    player = AudioPlayer();
    //player?.setAsset("caller_tone.mp3");

    _createPeerConnection().then((pc) {
      _peerConnection = pc;
      peerConnectionStatus();


    });
  }

  void disposeAudioVideoCall() async {
  stopCallerTone();
    await _localStream.dispose();
    await player?.dispose();
    if (_peerConnection != null) {
      _peerConnection?.close();
    }
    if (_timmerInstance != null) {
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
      startCallerTone();

      RTCSessionDescription description = await _peerConnection!

          .createOffer(
              isVideoCall ? offerVideoCallConstraints : offerAudioConstraints);

      _offer = true;
      _peerConnection!.setLocalDescription(description);

      HashMap<String, dynamic> offerData =
          HashMap.of({"type": "offer", "sdp": description.sdp.toString()});

      var createOffer = SocketMessageModel(
          type: SocketMessageType.CreateOffer.displayTitle,
          sendTo: targetUserId,
          sendFrom: currentUserId,
          data: offerData);

      socketService.sendMessageToWebSocket(createOffer);
    } catch (exception) {
      print("Offer create exception == $exception");
      if (exception
          .toString()
          .contains("Offer called when PeerConnection is closed")) {
        initializeState();
        createOffer();
      }
    }
  }



  void joinCall(SocketMessageModel answer) async {

    var answerCall = SocketMessageModel(
        type: SocketMessageType.JoinCall.displayTitle,
        sendTo: targetUserId,
        sendFrom: currentUserId,
        offerConnectionId: answer.offerConnectionId,
        data: true);
    socketService.sendMessageToWebSocket(answerCall);

  }




  void answerCall(SocketMessageModel answer) async {
    RTCSessionDescription description = await _peerConnection!
        // .createAnswer({"offerToReceiveVideo": 1, "offerToReceiveAudio": 1});
        .createAnswer(
            isVideoCall ? offerVideoCallConstraints : offerAudioConstraints);
    _peerConnection!.setLocalDescription(description);

    //var sdpSession = parse(description.sdp!); //parse(description.sdp!);
    //var type = parse(description.type!); //parse(description.type!);
    HashMap<String, dynamic> offerData =
        HashMap.of({"type": "answer", "sdp": description.sdp.toString()});
    var answerCall = SocketMessageModel(
        type: SocketMessageType.AnswerCall.displayTitle,
        sendTo: targetUserId,
        sendFrom: currentUserId,
        offerConnectionId: answer.offerConnectionId,
        data: offerData);


    socketService.sendMessageToWebSocket(answerCall);


    _peerConnection!.onIceCandidate = (e) {
      if (e.candidate != null) {
        HashMap<String, dynamic> candidate = HashMap.of({
          "candidate": e.candidate.toString(),
          "sdpMid": e.sdpMid.toString(),
          "sdpMLineIndex": e.sdpMlineIndex,
        });

        var iceCandidate = SocketMessageModel(
            type: SocketMessageType.SendIceCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: currentUserId,
            data: candidate);
        socketService.sendMessageToWebSocket(iceCandidate);

        //****** Send Candidate as per backend handle logic *********
        var sendCandidate = SocketMessageModel(
            type: SocketMessageType.SendCandidate.displayTitle,
            sendTo: targetUserId,
            sendFrom: currentUserId,
            data: candidate);
        socketService.sendMessageToWebSocket(sendCandidate);
        //********************************************
      }
    };


  }




  void setRemoteDescription(String jsonString) async {
    final body = json.decode(jsonString);

    // dynamic session = await jsonDecode(jsonString);

    //String sdp = write(session, null);
    RTCSessionDescription description =
        RTCSessionDescription(body["sdp"], _offer ? "answer" : "offer");
    await _peerConnection!.setRemoteDescription(description);
    _peerConnection!.onAddStream = (stream) {
      onAddRemoteStream(stream);
    };
  }


  void addCandidate(String jsonString) async {
    dynamic session = await jsonDecode(jsonString);

    dynamic candidate = RTCIceCandidate(
        session["candidate"], session["sdpMid"], session["sdpMLineIndex"]);

    await _peerConnection!.addCandidate(candidate);
  }

  void endCall(bool isUserClosedCall) async {
    await _localStream.dispose();
    if (_timmerInstance != null) {
      _timmerInstance?.cancel();
    }

    if (_peerConnection != null) {
      _peerConnection?.close();
    }
    if (isUserClosedCall) {
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

  void startCallerTone() async {
    String audioasset = "assets/sounds/caller_tone.mp3";
    await player?.setAsset(audioasset).then((value) {
      player?.setVolume(0.1);
      player?.setLoopMode(LoopMode.all);
      player?.play();
    });

    // player?.play();
  }

  void stopCallerTone() {
    player?.stop();
  }
}

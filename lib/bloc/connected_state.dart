part of 'connected_bloc.dart';

abstract class ConnectedState {}

class ConnectedInitialState extends ConnectedState {}

class ConnectedSucessState extends ConnectedState {}

class ConnectedFailureState extends ConnectedState {}

class FirebaseMsgReceived extends ConnectedState {
  Screen screenName;
  FirebaseMsgReceived({required this.screenName});
}

class SocketMessage extends ConnectedState{
  SocketMessageModel msg ;
  SocketService server;
  SocketMessage({required this.msg,required this.server});
}



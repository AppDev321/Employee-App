part of 'connected_bloc.dart';


abstract class ConnectedEvent {}

class OnConnectedEvent extends ConnectedEvent{}

class OnNotConnectedEvent extends ConnectedEvent{}

class OnFirebaseNotificationReceive extends ConnectedEvent{
  Screen screenName;
  OnFirebaseNotificationReceive({required this.screenName});
}




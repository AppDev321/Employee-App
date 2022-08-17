import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

part 'connected_event.dart';
part 'connected_state.dart';

class ConnectedBloc extends Bloc<ConnectedEvent, ConnectedState> {
  StreamSubscription? subscription;

  ConnectedBloc() : super(ConnectedInitialState()) {
    on<OnConnectedEvent>((event, emit) => emit(ConnectedSucessState()));
    on<OnNotConnectedEvent>((event, emit) => emit(ConnectedFailureState()));

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        add(OnConnectedEvent());
        print("onconnected to server");
      } else {
             add(OnNotConnectedEvent());
             print("not connected to server");
      }
    });
  }
  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}

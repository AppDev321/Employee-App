import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hnh_flutter/view_models/notification_vm.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../notification/firebase_notification.dart';
import '../../repository/model/response/get_notification.dart';
import '../../utils/controller.dart';
import '../../view_models/leave_list_vm.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';
import '../../widget/name_icon_badge.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  late NotificationViewModel _notificationViewModel;
 late List<NotificationData> notificationList=[] ;
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });
    _notificationViewModel = NotificationViewModel();
    _notificationViewModel.getNotification();
    _notificationViewModel.addListener(() {
   //  notificationList.clear();

      var checkErrorApiStatus = _notificationViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _notificationViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        _isFirstLoadRunning = false;
        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";


          notificationList = _notificationViewModel.notifications!;

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
        ),
        body: Column(
          children: [
            BlocBuilder<ConnectedBloc, ConnectedState>(
                builder: (context, state) {
              if (state is ConnectedFailureState) {
                return const InternetNotAvailable();
              } else if (state is FirebaseMsgReceived) {
                return Container();
              } else {
                return Container();
              }
            }),
            _isFirstLoadRunning
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : _isErrorInApi
                    ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                    : Expanded(
                        child: notificationList.isNotEmpty
                            ? RefreshIndicator(
                                onRefresh:
                                    _notificationViewModel.getNotification,
                                child: ListView.builder(
                                    itemCount: notificationList.length,
                                    itemBuilder: (context, index) {
                                      return Slidable(
                                        key: const ValueKey(0),
                                        endActionPane: ActionPane(
                                          motion: const ScrollMotion(),
                                          //dismissible: DismissiblePane(onDismissed: () {}),
                                          children: [
                                            SlidableAction(
                                              onPressed: (value) {

                                                setState(() {
                                                  _notificationViewModel.deleteNotificationStatus(notificationList[index].id.toString());
                                                  notificationList.remove(notificationList[index]);

                                                  FBroadcast.instance().broadcast(Controller().notificationBroadCast, value: Controller().fcmMsgValue);

                                                });
                                              },
                                              backgroundColor:  const Color(0xFFFE4A49),
                                              foregroundColor: Colors.white,
                                              icon: Icons.delete,
                                              label: 'Delete',
                                            ),
                                          ],
                                        ),
                                        child: itemNotificationList(index),
                                      );
                                    }),
                              )
                            : const ErrorMessageWidget(
                                label: "No Notification Found"),
                      )
          ],
        ));
  }

  Widget makeListTile(NotificationData notificationData, int index) {
    var item = notificationData.notificationData!;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.zero,
        /*  decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.grey))),*/

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Icon(
                Icons.notifications_rounded,
                size: 30,
              ),
            ]),
      ),
      title: CustomTextWidget(
          text: item.title.toString(), fontWeight: FontWeight.bold),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          CustomTextWidget(
            text: Controller()
                .getServerDateFormated(notificationData.createdAt.toString()),
            color: Colors.grey,
            size: 10,
          ),
          const SizedBox(
            height: 5,
          ),
          CustomTextWidget(
            text: item.body.toString(),
            color: Colors.grey,
            size: 12,
          ),
        ],
      ),
      trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
                size: 30.0,
              ),
              onTap: () {
                setState(() {
                  _notificationViewModel.updateNotificationStatus(notificationData.id.toString());
                  notificationData.isRead = 1;
                  notificationList[index] = notificationData;
                  FBroadcast
                      .instance()
                      .broadcast(
                      Controller().notificationBroadCast,
                      value: Controller().fcmMsgValue);

                });

                if (notificationData.type.toString() == 'TEXT') {
                  var screenName = item.activity ?? 'N/A';
                  if (!screenName
                      .toString()
                      .toLowerCase()
                      .contains("dashboard")) {
                    LocalNotificationService().navigateFCMScreen(screenName);
                  }
                }
              },
            )
          ]),
    );
  }

  Widget itemNotificationList(int index) {
    var item = notificationList[index];
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Stack(children: <Widget>[
        item.isRead == 0
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  color: Colors.red,
                  child: const CustomTextWidget(
                    text: "New",
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              )
            : Container(),
        makeListTile(item, index)
      ]),
    );
  }
}

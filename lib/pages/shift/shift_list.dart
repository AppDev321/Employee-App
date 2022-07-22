import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/view_models/shift_list_vm.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../custom_style/colors.dart';
import '../../custom_style/strings.dart';
import '../../custom_style/text_style.dart';
import '../../notification/firebase_notification.dart';
import '../../repository/model/request/claim_shift_request.dart';
import '../../widget/calander_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/navigation_drawer_new.dart';
import '../login/login.dart';

class ShiftList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShiftListState();
  }
}

class ShiftListState extends State<ShiftList> with TickerProviderStateMixin {
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<Shifts> _shiftList = [];
  List<Shifts> _openShiftList = [];

  late BuildContext contextBuild;
  late ShiftListViewModel _shiftListViewModel;

  CalendarController _controller = CalendarController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    firebaseMessaging(context);
    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _shiftListViewModel = ShiftListViewModel();
    _shiftListViewModel.addListener(() {
      _shiftList.clear();
      _openShiftList.clear();

      var checkErrorApiStatus = _shiftListViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _shiftListViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => LoginClass(),
              ),
              (route) =>
                  false, //if you want to disable back feature set to false
            );
          }
        });
      } else {
        _shiftList = _shiftListViewModel.getMyShiftList();
        _openShiftList = _shiftListViewModel.getOpenShiftList();
        _isFirstLoadRunning = false;

        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
      }

      //Check claim Status
      var isClaimSuccessFul = _shiftListViewModel.claimResponseSuccess;
      if (isClaimSuccessFul) {
        var snackBar = SnackBar(content: Text('Claim Successful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        String formattedDate = formatter.format(now);
        _shiftListViewModel.getShiftList(formattedDate);
        _shiftListViewModel.setClaimResponse(false);
      }

      var showClaimError = _shiftListViewModel.getClaimError();
      if (showClaimError) {
        var snackBar =
            SnackBar(content: Text(_shiftListViewModel.getErrorMsg()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _shiftListViewModel.setClaimError(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    contextBuild = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Weekly Shift'),
      ),
      drawer: NavigationDrawer(),
      body: Column(
        children: [
          CustomCalanderWidget(
            controller: _controller,
            onChanged: (String value) {
              setState(() {
                _shiftList.clear();
                _openShiftList.clear();
                _isFirstLoadRunning = true;
                _isErrorInApi = false;
                _shiftListViewModel.getShiftList(value);
              });
            },
          ),
          _isFirstLoadRunning
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : _isErrorInApi
                  ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                  : Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              color: primaryColor,
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.white,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white54,
                                tabs: [
                                  Tab(text: 'My Shift'),
                                  Tab(text: 'Open Shift')
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _shiftList.length > 0
                                        ? showListData(
                                            context, _shiftList, false)
                                        : Expanded(
                                            child: ErrorMessageWidget(
                                                label: "No Shift Found")),
                                    _openShiftList.length > 0
                                        ? showListData(
                                            context, _openShiftList, true)
                                        : Expanded(
                                            child: ErrorMessageWidget(
                                                label: "No Open  Shift Found"))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget showListData(
      BuildContext context, List<Shifts> shifts, bool openShiftData) {
    return ListView.builder(
      itemCount: shifts.length,
      itemBuilder: (_, index) => Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: indexBuilder(context, index, shifts, openShiftData),
      ),
    );
  }

  Widget indexBuilder(BuildContext context, int index, List<Shifts> shifts,
      bool openShiftData) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    final data = shifts[index];
    return ExpansionTile(
      title: LayoutBuilder(
        builder: (context, constraint) {
          return Container(
              width: constraint.maxWidth,
              height: 140,
              child: itemShiftList(context, data, openShiftData));
        },
      ),
      children: <Widget>[
        openShiftData
            ? ListTile(
                title: LayoutBuilder(
                  builder: (context, constraint) {
                    return Container(child: itemOpenShiftDetail(context, data));
                  },
                ),
              )
            : ListTile(
                title: LayoutBuilder(
                  builder: (context, constraint) {
                    return Container(child: itemShiftDetail(context, data));
                  },
                ),
              )
      ],
    );
  }

  Widget itemShiftList(BuildContext context, Shifts item, bool openShift) {
    var isClaimed = item.claimed;
    if (isClaimed == null) {
      isClaimed = false;
    }

    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          isClaimed
              ? SizedBox(
                  width: 20,
                  child: Container(color: Colors.orangeAccent),
                )
              : SizedBox(
                  width: 20,
                  child: Container(color: primaryColor),
                ),
          Flexible(
              //padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    openShift
                        ? Container()
                        : Text(
                            item.empName ?? 'N/A',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: normalBoldTextStyle,
                          ),
                    Text(
                      item.designation ?? 'N/A',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: primaryColor,
                          size: 20.0,
                        ),
                        Text(
                          item.location ?? 'N/A',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Shift Date:",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("${item.date}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text("Shift Time:",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text("${item.shiftTime}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget itemShiftDetail(BuildContext context, Shifts item) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: <Widget>[
          Flexible(
              child:    detailInfoItems(item)
          )
        ],
      ),
    );
  }

  Widget itemOpenShiftDetail(BuildContext context, Shifts item) {
    var isClaimed = item.claimed;
    if (isClaimed == null) {
      isClaimed = false;
    }

    return InkWell(
      onTap: () {},
      child: Column(
        children: [

          detailInfoItems(item),
          isClaimed
              ? Row(
                  children: [
                    Text("Claim Status:", style: normalBoldTextStyle),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text("Already Claimed"))
                  ],
                )
              : Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      setState(() {
                        _isFirstLoadRunning = true;
                        _isErrorInApi = false;
                        var request = ClaimShiftRequest();
                        request.openShiftId = item.id.toString();
                        _shiftListViewModel.claimOpenShift(request);
                      });
                    },
                    child: Text('Claim this Shift'),
                  ),
                ),
        ],
      ),
    );
  }

  Widget subInformation(Shifts item) {
    return Column(children: [
      Row(
        children: [
          Text("Name:", style: normalBoldTextStyle),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text("${item.empName == '' ? 'N/A' : item.empName}"),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text("Designation:", style: normalBoldTextStyle),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text("${item.designation == '' ? 'N/A' : item.designation}"),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text("Location:", style: normalBoldTextStyle),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text("${item.location == '' ? 'N/A' : item.location}"),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text("Shift Date:", style: normalBoldTextStyle),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text("${item.date}"),
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      Row(
        children: [
          Text("Shift Time:", style: normalBoldTextStyle),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "${item.shiftTime}",
            ),
          )
        ],
      ),
    ]);
  }

  Widget detailInfoItems(Shifts item)
  {
    return Column(children:[
      Row(
        children: [
          Container(
              child: Text(
                "Break Time:",
                style: normalBoldTextStyle,
              )),
          Container(
              child: Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "${item.shiftBreak == '' ? 'N/A' : item.shiftBreak}",
                      ))))
        ],
      ),

      Row(
        children: [
          Container(
              child: Text(
                "Vehicle:",
                style: normalBoldTextStyle,
              )),
          Container(
              child: Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "${item.vehicle == '' ? 'N/A' : item.vehicle}",
                      ))))
        ],
      ),
      Row(
        children: [
          Container(
              child: Text(
                "Notes:",
                style: normalBoldTextStyle,
              )),
          Container(
              child: Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "${item.note == '' ? 'N/A' : item.note}",
                      ))))
        ],
      ),
    ]);
  }




  //Notificaiton


  void firebaseMessaging(BuildContext context) {



    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp ......!');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {

        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['title']}");
          print("message.data22 ${message.data['body']}");
        }

        LocalNotificationService.createandDisplayNotification(message);
        /* flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));*/
      }
    });



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }

}

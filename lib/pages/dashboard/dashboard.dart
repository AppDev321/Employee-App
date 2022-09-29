import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/leave/add_my_leave.dart';
import 'package:hnh_flutter/pages/overtime/overtime_list.dart';
import 'package:hnh_flutter/pages/profile/setting_screen.dart';
import 'package:hnh_flutter/pages/shift/shift_list.dart';
import 'package:hnh_flutter/view_models/dashbboard_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:provider/provider.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../main.dart';
import '../../provider/theme_provider.dart';
import '../../repository/model/response/get_dashboard.dart';
import '../../repository/model/response/get_shift_list.dart';
import '../../utils/controller.dart';
import '../../webservices/APIWebServices.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/image_slider.dart';
import '../../widget/internet_not_available.dart';
import '../../widget/name_icon_badge.dart';
import '../../widget/navigation_drawer_new.dart';
import '../notification_history/notification_list.dart';
import '../overtime/add_overtime.dart';
import '../profile/components/profile_pic.dart';
import '../reports/attendance_report.dart';
import '../reports/leave_report.dart';
import '../vehicletab/scan_vehicle_tab.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<DashBoardGrid> listStats = [];
  List<DashBoardGrid> listQuickAccess = [];
  bool _isFirstLoadRunning = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  bool _isErrorInApi = false;
  String? _errorMsg = "";
  late DashBoardViewModel _dashBoardViewModel;

  Shifts? dashBoardShift = null;
  Stats? dashboardStat = null;
  User userDashboard = User();
  String profileImageUrl = "";

  Map<String, String> map = {
    'device_type': platFormType!.toLowerCase(),
    'fcm_token': fcmToken!
  };

  int notificationCount = 0;

  bool isAppUpdateRequired = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    APIWebService().postTokenToServer(map);

    _dashBoardViewModel = DashBoardViewModel();
    _dashBoardViewModel.initFireBaseConfig();
    _dashBoardViewModel.getDashBoardData();
    _dashBoardViewModel.isAppUpdated().then((value) {
      if (value != null) {
        _dashBoardViewModel.showVersionDialog(
            context, value.downloadUrl.toString());
      }
    });

    _dashBoardViewModel.getBackgroundFCMNotificaiton();

    _dashBoardViewModel.addListener(() {
      notificationCount = _dashBoardViewModel.notificationCount;
      var checkErrorApiStatus = _dashBoardViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _dashBoardViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        _isFirstLoadRunning = false;
        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
          dashBoardShift = _dashBoardViewModel.getDashBoardShift();
          dashboardStat = _dashBoardViewModel.getDashboardStat();
          userDashboard = _dashBoardViewModel.getUserObject()!;
          if (userDashboard.profileURL == null) {
            userDashboard.profileURL = "";
          }

          profileImageUrl = userDashboard.profileURL.toString();
          Controller().setUserProfilePic(profileImageUrl);

          if (dashboardStat != null) {
            listStats.clear();
            listStats.add(DashBoardGrid(
                dashboardStat!.totalShifts.toString(),
                "Total Shifts",
                "assets/icons/shifts_icon.svg",
                claimedShiftApprovedColor));
            listStats.add(DashBoardGrid(dashboardStat!.leaves.toString(),
                "Total Leaves", "assets/icons/leave_icon.svg", Colors.red));
            listStats.add(DashBoardGrid(
                Controller()
                    .differenceFormattedString(dashboardStat!.totalTime!),
                "Total Overtime",
                "assets/icons/overtime_icon.svg",
                Colors.deepPurple));
          }
        });
      }
    });

    setState(() {
      listStats.add(DashBoardGrid("0", "Total Shifts",
          "assets/icons/shifts_icon.svg", claimedShiftApprovedColor));
      listStats.add(DashBoardGrid(
          "0", "Total Leaves", "assets/icons/leave_icon.svg", Colors.red));
      listStats.add(DashBoardGrid("0", "Total Overtime",
          "assets/icons/overtime_icon.svg", Colors.deepPurple));
    });

    setState(() {
      listQuickAccess.add(DashBoardGrid("1", "Leave Request",
          "assets/icons/leave_icon.svg", claimedShiftApprovedColor));
      listQuickAccess.add(DashBoardGrid("2", "Overtime Request",
          "assets/icons/overtime_icon.svg", claimedShiftColor));
      listQuickAccess.add(DashBoardGrid("3", "Attendance Report",
          "assets/icons/reports_icon.svg", Colors.blueGrey));
      listQuickAccess.add(DashBoardGrid(
          "4", "Settings", "assets/icons/Settings.svg", greenColor));
    });

    FBroadcast.instance().register(
      Controller().notificationBroadCast,
      (value, callback) {
        setState(() {
          if (value == Controller().fcmMsgValue) {
            _dashBoardViewModel.getNotificationCount();
          }
        });
      },
      more: {
        /// register Key_User reviver
        Controller().userKey: (value, callback) => setState(() {
              profileImageUrl = value;
              Controller().setUserProfilePic(value);
            }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {



    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          var colorText = themeNotifier.isDark ? blackThemeTextColor : primaryColor;
          return Scaffold(
          drawer: NavigationDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: colorText),
            elevation: 0,
            titleSpacing: 10,
            backgroundColor:  themeNotifier.isDark ? Colors.black : Colors.white,
            title: Align(
              alignment: Alignment.centerLeft,
              child: CustomTextWidget(
                text: Controller().greeting(),
                size: 22,
                color: colorText,
              ),
          ),
          actions: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                    child: IconButton(
                        icon: Icon(Icons.qr_code,
                            color: colorText,
                            size: 22),
                        onPressed: () {
                          Get.to(() => VehicleTabScan());
                        })
                ),
                Container(
                    child: IconButton(
                        icon: Icon(themeNotifier.isDark
                            ? Icons.nightlight_round
                            : Icons.wb_sunny,
                            size: 22),
                        onPressed: () {
                          themeNotifier.isDark
                              ? themeNotifier.isDark = false
                              : themeNotifier.isDark = true;
                          _refreshIndicatorKey.currentState?.show();
                        })
                ),
                Container(
                  child: NamedIcon(
                    onTap: () => Get.to(() => NotificationList()),
                    notificationCount: notificationCount,
                    iconData: Icons.notifications,
                    color: colorText,
                  ),
                ),

              ],
            )
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<ConnectedBloc, ConnectedState>(
                builder: (context, state) {
              if (state is ConnectedFailureState) {
                return InternetNotAvailable();
              } else if (state is FirebaseMsgReceived) {
                if (state.screenName == Screen.DASHBOARD) {
                  _dashBoardViewModel.getDashBoardData();
                  state.screenName = Screen.NULL;
                }
                return Container();
              } else {
                return Container();
              }
            }),
            Expanded(
              child: RefreshIndicator(
                key:_refreshIndicatorKey,
                onRefresh: _dashBoardViewModel.getDashBoardData,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 25, 25),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: "Hello,",
                                    size: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor.withOpacity(0.5),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextWidget(
                                    text: userDashboard.name ?? 'Employee',
                                    size: 30,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ],
                              ),
                              ProfilePic(
                                profileImageUrl: profileImageUrl,
                                width: 80,
                                height: 80,
                                isEditable: false,
                              ),
                            ],
                          ),
                          dashBoardShift != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: CustomTextWidget(
                                            text: dashBoardShift?.todayShift ==
                                                    true
                                                ? "Today Shift"
                                                : "Upcoming Shift",
                                            size: 18,
                                            color: primaryColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    upComingShift(
                                        Colors.blueGrey, dashBoardShift!),
                                  ],
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          CustomTextWidget(
                              text: "Events", size: 18, color: primaryColor),
                          SizedBox(
                            height: 10,
                          ),
                          ImageSliderWidget(
                            height: 135,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: CustomTextWidget(
                                      text: "Your Stats",
                                      size: 18,
                                      color: primaryColor),
                                ),
                              ),
                              TextColorContainer(
                                  label: "Monthly",
                                  color: claimedShiftApprovedColor),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listStats.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 2 / 2,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                                crossAxisCount: 3,
                              ),
                              itemBuilder: (ctx, i) {
                                var data = listStats[i];
                                return statsContainerItem(data);
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: CustomTextWidget(
                                  text: "Quick Access",
                                  size: 18,
                                  color: primaryColor),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listQuickAccess.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (ctx, i) {
                                var data = listQuickAccess[i];
                                return quickAccess(data);
                              }),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget upComingShift(Color color, Shifts item) {
    return Card(
      elevation: 5,
      shadowColor: cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Controller.roundCorner),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: Get.mediaQuery.size.width,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(Controller.roundCorner),
                topRight: Radius.circular(Controller.roundCorner))),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/calendar_icon.svg",
                      color: Colors.white,
                      width: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomTextWidget(
                      text: item.date.toString(),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/Location point.svg",
                      color: Colors.white,
                      width: 15,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomTextWidget(
                      text: item.location.toString(),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/shifts_icon.svg",
                  color: Colors.white,
                  width: 22,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomTextWidget(
                  text: item.shiftTime,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget statsContainerItem(DashBoardGrid item) {
    return InkWell(
      onTap: () {
        if (item.label.toString().contains("Shift")) {
          Get.to(() => ShiftList());
        } else if (item.label.toString().contains("Leaves")) {
          Get.to(() => LeaveReport());
        } else {
          Get.to(() => OverTimePage());
        }
      },
      child: Card(
          elevation: 5,
          shadowColor: cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Controller.roundCorner),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: Get.mediaQuery.size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))),
            margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  item.imgPath.toString(),
                  color: item.color,
                  width: 22,
                  height: 22,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: CustomTextWidget(
                    text: item.id.toString(),
                    color: item.color!,
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: CustomTextWidget(
                    text: item.label.toString(),
                    size: 10,
                    color: item.color!,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget quickAccess(DashBoardGrid item) {
    return InkWell(
        onTap: () {
          var id = int.parse(item.id.toString());

          switch (id) {
            case 1:
              Get.to(() => AddLeave(
                    leaveTypes: _dashBoardViewModel.leaveTypes,
                  ));
              break;
            case 2:
              Get.to(() => AddOverTime());
              break;
            case 3:
              Get.to(() => AttendanceReport());
              break;
            case 4:
              Get.to(() => SettingScreen());
              break;
          }
        },
        child: Card(
            color: item.color,
            elevation: 5,
            shadowColor: cardShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Controller.roundCorner),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: Get.mediaQuery.size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(Controller.roundCorner),
                      topRight: Radius.circular(Controller.roundCorner))),
              margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    item.imgPath.toString(),
                    color: Colors.white,
                    width: 22,
                  ),
                  SizedBox(height: 10),
                  CustomTextWidget(
                    text: item.label.toString(),
                    color: Colors.white,
                    size: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            )));
  }
}

class DashBoardGrid {
  String? id;
  String? label;
  String? imgPath;
  Color? color;

  DashBoardGrid(String count, String label, String path, Color color) {
    this.id = count;
    this.label = label;
    this.color = color;
    this.imgPath = path;
  }
}

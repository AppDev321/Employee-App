import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/leave/add_my_leave.dart';
import 'package:hnh_flutter/view_models/dashbboard_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../main.dart';
import '../../repository/model/response/get_dashboard.dart';
import '../../repository/model/response/get_shift_list.dart';
import '../../utils/controller.dart';
import '../../webservices/APIWebServices.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/internet_not_available.dart';
import '../../widget/navigation_drawer_new.dart';
import '../notification_history/notification_list.dart';
import '../overtime/add_overtime.dart';
import '../profile/components/profile_pic.dart';
import '../reports/attendance_report.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<DashBoardGrid> listStats = [];
  List<DashBoardGrid> listQuickAccess= [];
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";
  late DashBoardViewModel _dashBoardViewModel;

  Shifts? dashBoardShift = null;
  Stats? dashboardStat = null;
  User? userDashboard= null;


  Map<String,String> map = {
    'device_type': platFormType!,
    'fcm_token':fcmToken!
  };

  int notificationCount =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    APIWebService().postTokenToServer(map);


    _dashBoardViewModel = DashBoardViewModel();
    _dashBoardViewModel.getDashBoardData();
  //  _dashBoardViewModel.firebaseMessaging(context);
    _dashBoardViewModel.addListener(() {


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
          userDashboard = _dashBoardViewModel.getUserObject();
          if(dashboardStat != null)
            {
              listStats.clear();
              listStats.add(DashBoardGrid(dashboardStat!.totalShifts.toString(), "Total Shifts","assets/icons/shifts_icon.svg",claimedShiftApprovedColor));
              listStats.add(DashBoardGrid(dashboardStat!.leaves.toString(), "Total Leaves","assets/icons/leave_icon.svg",Colors.red));
              listStats.add(DashBoardGrid(Controller().differenceFormattedString(dashboardStat!.totalTime!), "Total Overtime","assets/icons/overtime_icon.svg",Colors.deepPurple));
            }

        });
      }
    });

    
    setState(() {
      listStats.add(DashBoardGrid("0", "Total Shifts","assets/icons/shifts_icon.svg",claimedShiftApprovedColor));
      listStats.add(DashBoardGrid("0", "Total Leaves","assets/icons/leave_icon.svg",Colors.red));
      listStats.add(DashBoardGrid("0", "Total Overtime","assets/icons/overtime_icon.svg",Colors.deepPurple));
    });




    setState(() {

      listQuickAccess.add(DashBoardGrid("1", "Leave Request","assets/icons/leave_icon.svg",claimedShiftApprovedColor));
      listQuickAccess.add(DashBoardGrid("2", "Overtime Request","assets/icons/overtime_icon.svg",claimedShiftColor));
      listQuickAccess.add(DashBoardGrid("3", "Attendance Report","assets/icons/reports_icon.svg",Colors.blueGrey));
      listQuickAccess.add(DashBoardGrid("4", "Settings","assets/icons/Settings.svg",greenColor));
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: primaryColor),
        elevation: 0,
        titleSpacing: 10,
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.centerLeft,
          child: CustomTextWidget(
            text: Controller().greeting(),
            size: 22,
            color: primaryColor,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Get.to(()=>NotificationList());
            },
            child: Stack(
              children: <Widget>[
                Container(
                  width: 50,
                  child: Icon(
                    Icons.notifications,
                    color: primaryColor,
                    size: 35,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.red,
                    ),
                    width: 20,
                    height: 20,
                    child: Center(
                      child: Text(
                        notificationCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ConnectedBloc, ConnectedState>(
              builder: (context, state) {
                if (state is ConnectedFailureState) {
                  return InternetNotAvailable();
                }
                else if(state is FirebaseMsgReceived)
                  {
                    notificationCount ++;
                     if(state.screenName == Screen.DASHBOARD)
                    {
                      _dashBoardViewModel.getDashBoardData();
                      state.screenName=Screen.NULL;
                      print("updating Dashboard Screen");

                    }
                    return Container( );
                  }
                else
                {
                  return Container();
                }
              }
          ),
          Expanded(
            child: RefreshIndicator(
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
                                  text: userDashboard?.name ??  'Employee',
                                  size: 30,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ],
                            ),



                            Container(

                                child: Container(
                                  width: 80,
                                  height: 80,

                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: primaryColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: primaryColor.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                      image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                            )

                        ))))
                                  ,
                          ],
                        ),

                        dashBoardShift != null ?
                            Column(children: [
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: CustomTextWidget(
                                      text: dashBoardShift?.todayShift == true ? "Today Shift" : "Upcoming Shift",
                                      size: 18,
                                      color: primaryColor),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              upComingShift(Colors.blueGrey, dashBoardShift!),
                            ],)

                        : Container(),



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
                                    color:primaryColor),
                              ),
                            ),
                            TextColorContainer(
                                label: "Monthly", color: claimedShiftApprovedColor),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),




                        GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listStats.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2/2,
                              crossAxisSpacing: 3,
                              mainAxisSpacing:3,
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
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3/2,
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
  }

  Widget upComingShift(Color color,Shifts item) {
    return Card(

      elevation: 5,
      shadowColor: cardShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Controller.roundCorner),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: MediaQuery.of(context).size.width,
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
                    SizedBox(width: 10,),

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
                    SizedBox(width: 10,),

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
                SizedBox(width: 10,),

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

  Widget statsContainerItem(DashBoardGrid item)
  {
    return

      Card(

          elevation: 5,
          shadowColor: cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Controller.roundCorner),
          ),
          clipBehavior: Clip.antiAlias,
          child:
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))),
            margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
            Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
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
                    color:item.color!,
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
          ));
  }


  Widget quickAccess(DashBoardGrid item)
  {
    return
InkWell(
  onTap: (){
    var id = int.parse(item.id.toString());

    switch(id)
    {
      case 1:
        Get.to(()=>AddLeave(leaveTypes: _dashBoardViewModel.leaveTypes,));
        break;
      case 2:
        Get.to(()=>AddOverTime());
        break;
      case 3:
        Get.to(()=>AttendanceReport());
        break;
      case 4:
        Controller().showToastMessage(context,"In Progress");
        break;

    }


  },
  child:
    Card(
          color: item.color,
          elevation: 5,
          shadowColor: cardShadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Controller.roundCorner),
          ),
          clipBehavior: Clip.antiAlias,
          child:
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(

                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))),
            margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child:
            Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
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
          )))
    ;
  }




}






class DashBoardGrid {
  String? id;
  String? label;
  String? imgPath;
  Color? color;

  DashBoardGrid(String count, String label,String path,Color color) {
    this.id = count;
    this.label = label;
    this.color = color;
    this.imgPath = path;
  }
}

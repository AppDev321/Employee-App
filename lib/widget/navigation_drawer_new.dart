


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/data/drawer_item.dart';
import 'package:hnh_flutter/pages/availability/add_my_availability.dart';
import 'package:hnh_flutter/pages/leave/leave_listing.dart';
import 'package:hnh_flutter/pages/overtime/add_overtime.dart';
import 'package:hnh_flutter/pages/profile/profile_screen.dart';
import 'package:hnh_flutter/pages/reports/leave_report.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/pages/vehicletab/scan_vehicle_tab.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:provider/provider.dart';
import '../data/drawer_items.dart';
import '../main.dart';
import '../pages/attandence/add_attendance.dart';
import '../pages/availability/availability_listing.dart';
import '../pages/login/login.dart';
import '../pages/overtime/overtime_list.dart';
import '../pages/profile/setting_screen.dart';
import '../pages/reports/attendance_report.dart';
import '../pages/reports/lateness_report.dart';
import '../pages/shift/shift_list.dart';
import '../utils/controller.dart';

class NavigationDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 0);
  Map<String,String> map = {
    'device_type': 'android',
    'fcm_token':fcmToken!
  };

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return Container(
      width: isCollapsed ? MediaQuery.of(context).size.width * 0.2 : null,
      child: Drawer(
        child: Container(
          child: Column(
            children: [

              UserAccountsDrawerHeader(

                accountName: CustomTextWidget(text:ConstantData.appName,color: Colors.white,),
                accountEmail: CustomTextWidget(text:ConstantData.appVersion,color: Colors.white),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SizedBox(height: 50,width: 50,child:   Image.asset(ConstantData.logoIconPath) ),
                ),
              ),

          /*    Container(
                color:primaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.symmetric(vertical: 80).add(safeArea),
                      width: double.infinity,
                      child: buildHeader(isCollapsed),
                    ),
                  ),
                ),
              ),*/

              Expanded(
                  child:
              buildList(items: itemsFirst, isCollapsed: isCollapsed)
              )

             /* const SizedBox(height: 24),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isCollapsed: isCollapsed,
              ),
              Spacer(),
              buildCollapseIcon(context, isCollapsed),
              const SizedBox(height: 12),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            context: context,
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            item: item,
            onClicked: (){
              selectItem(context, indexOffset + index,item.title);

              },
          );
        },
      );


  Widget buildMenuItem(
      {

        required BuildContext context,
    required bool isCollapsed,
    required String text,
    required IconData icon,
    required DrawerItem item,
    required VoidCallback onClicked
  }) {

    var colorText =  borderColor;


    final leading =
    SvgPicture.asset(
      item.svgPath,
      width: 15,
      color:colorText ,

    );

    // Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(


        title: leading,
        onTap: onClicked,
      ) :
      item.contents.length > 0 ?

      ExpansionTile(

        title: CustomTextWidget(text:text),//new Text(text, style: new TextStyle(fontSize: 16,color: color),),
        leading: leading,

        children: <Widget>[
           Column(
            children: _buildExpandableContent( item,context ),
          ),
        ],
      ):
      ListTile(

        title: CustomTextWidget(text:text),//new Text(text, style: new TextStyle(fontSize: 16,color: color),),
        leading: leading,
        onTap: onClicked,
      )


      ,
    );
  }

  _buildExpandableContent(  DrawerItem vehicle,BuildContext context) {
    List<Widget> columnContent = [];

    for (String content in vehicle.contents) {
      columnContent.add(
         ListTile(
          title: CustomTextWidget(text:content),//new Text(content, style: new TextStyle(fontSize: 14.0),),
          onTap:()
            {
              selectItem(context,0,content);
              },
        ),
      );
    }

    return columnContent;
  }

  void selectItem(BuildContext context, int index,String menuItem) {

   // Navigator.of(context).pop();

    switch (menuItem) {

      case menuScanVehicleTab:
        Get.to(()=>VehicleTabScan());
        break;

      case menuAttandance:
        Get.to(()=>AddAttendance());
        break;
      case subMenuReportLateness:
        Get.to(()=>LatenessReport());
        break;
      case subMenuReportLeave:
        Get.to(()=>LeaveReport());
        break;
      case subMenuReportAttandance:
        Get.to(()=>AttendanceReport());
        break;
      case availability:
        Get.to(()=>AvailabilityList());
        break;
      case profile:
        Get.to(()=>MyAccount());
        break;
      case overtime:
        Get.to(()=>OverTimePage());
        break;
      case menuLeave:
        Get.to(()=>LeavePage());
        break;
      case subMenuMyShift:
        Get.to (()=>ShiftList());
        break;
      case subMenuOpenShift:
        Get.to(()=>ClaimedShiftList());
        break;

      case subMenuMyShift:
        Get.to(()=>ShiftList());
        break;

      case "Logout":
        Controller().showMessageDialog(context,
          "Are you sure you want to logout ?","Logout",
                (){
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Controller().logoutUser();
            },);
        break;
    }
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ?SizedBox(height: 48,width: 48,child:   Image.asset(ConstantData.logoIconPath) )
      : Column(
          children: [
            const SizedBox(width: 24),
            SizedBox(height: 48,width: 48,child:   Image.asset(ConstantData.logoIconPath) ),
            const SizedBox(width: 16),
            const Text(
              ConstantData.appName,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}


import 'package:flutter/material.dart';
import 'package:hnh_flutter/data/drawer_item.dart';

/*
final itemsFirst = [
  DrawerItem(title: 'Vehicles', icon: Icons.car_rental),

];

final itemsSecond = [
  DrawerItem(title: 'Deployment', icon: Icons.cloud_upload),
  DrawerItem(title: 'Resources', icon: Icons.extension),
];
*/

const String menuVehicle="Vehicle";

const String menuShift="Shift";
const String subMenuMyShift="My Shift";
const String subMenuOpenShift="Claimed History";
const String overtime = "Overtime";
const String menuAttandance="Attandence";
const String subMenuToday="Today";
const String menuLeave="Leave";
const String profile = "Profile";
const String availability = "Availability";
const String menuScanVehicleTab="Scan Vehicle Device";


const String menuReport="Reports";
const String subMenuReportAttandance="Attendance Report";
const String subMenuReportLeave="Leave Report";
const String subMenuReportLateness="Lateness Report";
const String todo=" (To Do..)";
const iconPath= "assets/icons/";


List<DrawerItem> itemsFirst = [
  /* DrawerItem(
    menuVehicle,
    [],
    Icons.car_rental,
  ),
   DrawerItem(
    menuAttandance,
    [subMenuToday, subMenuMyLeave],
    Icons.access_time,
  ),

*/
  DrawerItem(
      menuShift,
      [
        subMenuMyShift,
        subMenuOpenShift,

      ],
      Icons.analytics_outlined,
      iconPath+"shifts_icon.svg"
  ),

  /*  DrawerItem(
      menuAttandance,
    [],
    Icons.analytics_outlined,
      iconPath+"calendar_icon.svg"
  ),*/
  DrawerItem(
      menuLeave,
      [],
      Icons.analytics_outlined,
      iconPath+"shifts_icon.svg"
  ),
  /* DrawerItem(
    "Account$todo",
    [],
    Icons.analytics_outlined,
      iconPath+"shifts_icon.svg"
  ),*/

  /* DrawerItem(
    "Payment$todo",
    [],
    Icons.analytics_outlined,
      iconPath+"Cash.svg"
  ),*/
  DrawerItem(
      menuReport,
      [
        subMenuReportAttandance,subMenuReportLeave,subMenuReportLateness
      ],
      Icons.analytics_outlined,
      iconPath+"reports_icon.svg"
  ),

  DrawerItem(
      availability,
      [],
      Icons.analytics_outlined,
      iconPath+"shifts_icon.svg"
  ),

  DrawerItem(
      overtime,
      [],
      Icons.analytics_outlined,
      iconPath+"overtime_icon.svg"
  ),

  DrawerItem(
      menuScanVehicleTab,
      [],
      Icons.analytics_outlined,
      iconPath+"ic_qr_code.svg"
  ),


  DrawerItem(
      profile,
      [],
      Icons.analytics_outlined,
      iconPath+"User.svg"
  ),
  DrawerItem(
      "Logout",
      [],
      Icons.analytics_outlined,
      iconPath+"Log out.svg"
  ),

];
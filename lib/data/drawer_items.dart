
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
const String subMenuMyShift="Open Shift";
const String subMenuOpenShift="Claimed History";
const String overtime = "Overtime";
const String menuAttandance="Attandence";
const String subMenuToday="Today";
const String menuLeave="Leave";
const String profile = "Profile";
const String availability = "Availability"+" (In Progress)";



const String menuReport="Reports";
const String subMenuReportAttandance="Attendance Report";
const String subMenuReportLeave="Leave Report";
const String subMenuReportLateness="Lateness Report";
const String todo=" (To Do..)";

List<DrawerItem> itemsFirst = [
  /*new DrawerItem(
    menuVehicle,
    [],
    Icons.car_rental,
  ),
  new DrawerItem(
    menuAttandance,
    [subMenuToday, subMenuMyLeave],
    Icons.access_time,
  ),

*/
  new DrawerItem(
    menuShift,
    [
      subMenuOpenShift
    ],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    "Attendance$todo",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    menuLeave,
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Account$todo",
    [],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    "Payment$todo",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    menuReport,
    [
      subMenuReportAttandance,subMenuReportLeave,subMenuReportLateness
    ],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    availability,
    [],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    overtime,
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    profile,
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Logout",
    [],
    Icons.analytics_outlined,
  ),

];
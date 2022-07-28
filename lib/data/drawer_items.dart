
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

const String menuAttandance="Attandence";
const String subMenuToday="Today";
const String subMenuMyLeave="My Leave";



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
    "Attendance",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Leaves",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Account",
    [],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    "Payment",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Reports",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Claims",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Availablity",
    [],
    Icons.analytics_outlined,
  ),

  new DrawerItem(
    "Overtime",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Profile",
    [],
    Icons.analytics_outlined,
  ),
  new DrawerItem(
    "Logout",
    [],
    Icons.analytics_outlined,
  ),

];
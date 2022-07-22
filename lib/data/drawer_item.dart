import 'package:flutter/material.dart';

/*class DrawerItem {
  final String title;
  final IconData icon;
  final List<DrawerItem> children;
  const DrawerItem(this.title,this.icon, [this.children = const <DrawerItem>[]]);

}*/
class DrawerItem {
  final String title;
  List<String> contents = [];
  final IconData icon;

  DrawerItem(this.title, this.contents, this.icon);
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_style/colors.dart';
import '../utils/controller.dart';

class CustomFilterTab extends StatelessWidget {
  CustomFilterTab({
    Key? key,
    required this.controller,
    required this.tabs,
  }) : super(key: key);

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: kToolbarHeight - 8.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(Controller.roundCorner),
        ),
        child: TabBar(
          controller: controller,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(Controller.roundCorner), color: primaryColor),
          labelColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.normal),
          unselectedLabelColor: Colors.black,
          tabs: tabs,
        ));
  }
}

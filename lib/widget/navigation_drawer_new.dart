


import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/data/drawer_item.dart';
import 'package:hnh_flutter/pages/leave/my_leave_list.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../data/drawer_items.dart';
import '../main.dart';
import '../pages/login/login.dart';
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

          color:whiteColor,
          child: Column(
            children: [

              UserAccountsDrawerHeader(
                accountName: Text(ConstantData.appName),
                accountEmail: Text(ConstantData.appVersion),
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
    final color = Colors.black87;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
        title: leading,
        onTap: onClicked,
      ) :
      item.contents.length > 0 ?

      ExpansionTile(
        title: new Text(text, style: new TextStyle(fontSize: 16,color: color),),
        leading: leading,
        children: <Widget>[
          new Column(
            children: _buildExpandableContent( item,context ),
          ),
        ],
      ):
      ListTile(
        title: new Text(text, style: new TextStyle(fontSize: 16,color: color),),
        leading: leading,
        onTap: onClicked,
      )


      ,
    );
  }





  _buildExpandableContent(  DrawerItem vehicle,BuildContext context) {
    List<Widget> columnContent = [];

    for (String content in vehicle.contents)
      columnContent.add(
        new ListTile(
          title: new Text(content, style: new TextStyle(fontSize: 14.0),),
          onTap:()
            {
              selectItem(context,0,content);
              },
        ),
      );

    return columnContent;
  }


  void selectItem(BuildContext context, int index,String menuItem) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (menuItem) {
      case menuVehicle:
      //  navigateTo(GetStartedPage());
        break;
      case subMenuOpenShift:
        navigateTo(ClaimedShiftList());
        break;

      case subMenuMyShift:
        navigateTo(ShiftList());
        break;

      case "Logout":
        Controller controller = Controller();
        controller.setRememberLogin(false);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => LoginClass(),
          ),
              (route) =>
          false, //if you want to disable back feature set to false
        );
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
            Text(
              ConstantData.appName,
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}

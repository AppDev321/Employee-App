import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String? text;
  final VoidCallback? onTap;
  final int notificationCount;

  const NamedIcon({
    Key? key,
    this.onTap,
    this.text,
    required this.iconData,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData,size: 35,),
              text !=null?  Text(text.toString(), overflow: TextOverflow.ellipsis):Container(),
              ],
            ),
            Positioned(
              top: 0,
              right:10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: CustomTextWidget(text:'$notificationCount',color:Colors.white,size: 8,),
              ),
            )
          ],
        ),
      ),
    );
  }
}


/*

NamedIcon(
text: 'Inbox',
iconData: Icons.notifications,
notificationCount: 11,
onTap: () {},
)*/

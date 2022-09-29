import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String? text;
  final VoidCallback? onTap;
  final int notificationCount;
  final Color color;

  const NamedIcon({
    Key? key,
    this.onTap,
    this.text,
    required this.iconData,
    this.notificationCount = 0,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData,size: 25,color: color,),
              text !=null?  Text(text.toString(), overflow: TextOverflow.ellipsis):Container(),
              ],
            ),
            notificationCount >0 ?
            Positioned(
              top: 5,
              right:5,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: CustomTextWidget(text:'$notificationCount',color:Colors.white,size: 8,),
              ),
            ):Center()
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

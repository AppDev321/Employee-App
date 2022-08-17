import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../utils/controller.dart';


class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: primaryColor,
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(Controller.roundCorner)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: Colors.black54,
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: CustomTextWidget(text:text)),
            Icon(Icons.arrow_forward_ios ,color: Colors.black54,),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../custom_style/colors.dart';

class CustomTextWidget extends StatelessWidget {
  final String? text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final VoidCallback? onClick;
  final int maxLines ;
  final TextAlign textAlign;

  const CustomTextWidget({
    @required this.text,
    this.size =14,
    this.fontWeight=FontWeight.normal,
    this.color=Colors.black,
    this.onClick=null,
    this.maxLines=10000000000000000,
    this.textAlign = TextAlign.left
  });

  @override
  Widget build(BuildContext context) {
    var colorText = Get.isDarkMode ? blackThemeTextColor : color;

    return Container(
      child: onClick == null
          ? Text(
        text!,

        textAlign:textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,

        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: colorText

        ),
      )
          : TextButton(
        onPressed: () {
          onClick!.call();
        },
        child: Text(
          text!,
          textAlign:textAlign,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            color: colorText
          ),
        ),
      ),
    );
  }
}
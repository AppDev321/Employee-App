import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_style/colors.dart';

class CustomEditTextWidget extends StatelessWidget {
final String? text;
final bool isPasswordField;
final double size;
final FontWeight fontWeight;
final Color color;
final VoidCallback? onClick;
final TextEditingController? controller;

const CustomEditTextWidget({
@required this.text,
  this.isPasswordField=false,
this.size =14,
this.fontWeight=FontWeight.normal,
this.color=Colors.black,
this.onClick=null,
  this.controller = null
});

@override
Widget build(BuildContext context) {
  return
    controller == null ? TextField(
      obscureText: isPasswordField,
      decoration:boxContainer(text!) ,
    ):TextField(
     controller: controller,
      obscureText: isPasswordField,
      decoration:boxContainer(text!) ,
    );
}

InputDecoration boxContainer(String text)
{
  return InputDecoration(
      filled: true,
      fillColor:textFielBoxFillColor,
      hintText: text,
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: textFielBoxBorderColor, width: 1.0)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const  BorderSide(
              color: textFielBoxBorderColor,
              width: 1.0)));
}
}
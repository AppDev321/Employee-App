import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String? text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final VoidCallback? onClick;

  const CustomTextWidget({
    @required this.text,
    this.size =14,
    this.fontWeight=FontWeight.normal,
    this.color=Colors.black,
    this.onClick=null,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: onClick == null
          ? Text(
        text!,
        style: TextStyle(

          fontSize: size,
          fontWeight: fontWeight,
          color: color

        ),
      )
          : TextButton(
        onPressed: () {
          onClick!.call();
        },
        child: Text(
          text!,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            color: color

          ),
        ),
      ),
    );
  }
}
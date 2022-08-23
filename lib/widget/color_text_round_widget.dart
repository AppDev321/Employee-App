import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../utils/controller.dart';
import 'custom_text_widget.dart';

class TextColorContainer extends StatelessWidget {
  String label;
  Color color;
  IconData? icon;

  TextColorContainer({
    Key? key,
    required this.label,
    required this.color,
    this.icon,

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Controller.roundCorner),
        ),
        child:  icon == null ?
            CustomTextWidget(
                text: label,
                color: color,
              ):
        Icon(icon, size: 20,color: color)

      );
  }
}

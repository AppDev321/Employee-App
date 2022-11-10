import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../utils/size_config.dart';
import '../../../widget/custom_text_widget.dart';

class DialButton extends StatelessWidget {
  const DialButton({
    Key? key,
    required this.iconSrc,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String iconSrc, text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    var color = Get.isDarkMode ? Colors.white:Colors.black;
    return SizedBox(
      width: getProportionateScreenWidth(120),
      height: getProportionateScreenHeight(80),
      child:
      Center(
        child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    iconSrc,
                    color: color,
                    height: 36,
                  ),
                  const VerticalSpacing(of: 5),
                  CustomTextWidget(
                    text: text,
                    color: color,
                    size: 13,

                  ),

                ],
              ),
            ),
          ),
        ),

    );
  }
}

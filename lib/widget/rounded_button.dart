import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/utils/size_config.dart';


class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.size = 120,
    required this.iconSrc,
    this.color = Colors.white,
    this.iconColor = Colors.black,
    required this.press,
  }) : super(key: key);

  final double size;
  final String iconSrc;
  final Color color, iconColor;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(size),
      width: getProportionateScreenWidth(size),
      child:

      Column(children: [
        Padding(
          padding: EdgeInsets.all(15 / 64 * size),
          child:RawMaterialButton(
            onPressed: press,
            elevation: 2.0,
            fillColor: color,
            padding: const EdgeInsets.all(15.0),
            shape: const CircleBorder(),
            child: SvgPicture.asset(iconSrc, color: iconColor),
          ),
        )
      ],)
      ,
    );
  }
}

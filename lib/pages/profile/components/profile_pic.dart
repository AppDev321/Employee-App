import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../custom_style/colors.dart';

class ProfilePic extends StatelessWidget {
   ProfilePic({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [


          Container(
            width: 130,
            height: 130,

            decoration: BoxDecoration(
                border: Border.all(
                    width: 4,
                    color: primaryColor),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: primaryColor.withOpacity(0.1),
                      offset: Offset(0, 10))
                ],
                shape: BoxShape.circle,
              /*  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                    )

                )*/
            ),

            child: ClipOval( // make sure we apply clip it properly
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  color: primaryColor.withOpacity(0.1),
                  child: CustomTextWidget(text:name.toString().substring(0,1),size: 30,color: primaryColor,),
                ),
              ),
            ),


          ),

          Visibility(
              visible: false,
              child: Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          ))

        ],
      ),
    );
  }
}
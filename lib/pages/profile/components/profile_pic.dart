import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../custom_style/colors.dart';
import '../../../utils/controller.dart';

class ProfilePic extends StatelessWidget {
   ProfilePic({
    Key? key,

     required this.profileImageUrl
  }) : super(key: key);


   final   profileImageUrl ;

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
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      profileImageUrl.isEmpty ? Controller().defaultPic : profileImageUrl,
                     )

                )
            ),

            child: Container(   ),


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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../custom_style/colors.dart';
import '../../../utils/controller.dart';

class ProfilePic extends StatelessWidget {
  ProfilePic({
    Key? key,
    required this.profileImageUrl,
    this.width = 130,
    this.height = 130,
    this.isEditable = true,
    this.onEditClick = null,
  }) : super(key: key);

  final profileImageUrl;
  final ValueChanged<bool>? onEditClick;
  final double width;
  final double height;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: height,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: () {
              if (!profileImageUrl.isEmpty) {
                showDialog(
                    context: context,
                    builder: (_) => Controller().imageDialog("", profileImageUrl, context,isNetwork: true));
              }
            },
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                  border: Border.all(width: 4, color: primaryColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: primaryColor.withOpacity(0.1),
                        offset: const Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        profileImageUrl.isEmpty
                            ? Controller().defaultPic
                            : profileImageUrl,
                      ))),

            ),
          ),
          Visibility(
              visible: isEditable,
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
                        side: const BorderSide(color: Colors.white),
                      ),
                      primary: Colors.white,
                      backgroundColor: const Color(0xFFF5F6F9),
                    ),
                    onPressed: () {
                      onEditClick!(true);
                    },
                    child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
                  ),
                ),
              ))
        ],
      ),
    );
  }


}

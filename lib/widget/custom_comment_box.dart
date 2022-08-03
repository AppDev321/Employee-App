import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../repository/model/response/leave_list.dart';

class CustomCommentBox extends StatelessWidget {
  String label;

  String hintMessage;

  final TextEditingController? controller;

  CustomCommentBox({
    Key? key,
    required this.label,
    required this.hintMessage,
    this.controller = null,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return

      Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(text: label,fontWeight: FontWeight.bold,),
            SizedBox(height: 10,),
            TextFormField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(

                      hintText: hintMessage,
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: textFielBoxBorderColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1, color: textFielBoxBorderColor),
                        borderRadius: BorderRadius.circular(15),
                      )),

              ),
            ],

        );
  }
}

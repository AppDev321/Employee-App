import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../custom_style/colors.dart';
import '../utils/controller.dart';

class CustomEditTextWidget extends StatefulWidget {
  final String? text;
  bool isPasswordField;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final VoidCallback? onClick;
  final bool isNumberField;
  final TextEditingController? controller;

  CustomEditTextWidget({Key? key,
    @required this.text,
    this.isPasswordField = false,
    this.size = 14,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.onClick = null,
    this.isNumberField = false,
    this.controller = null}) : super(key: key);

  @override
  _CustomEditTextWidget createState() => _CustomEditTextWidget();
}

class _CustomEditTextWidget extends State<CustomEditTextWidget> {
bool showPass =true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus:false,
      keyboardType: widget.isNumberField ? TextInputType.number : TextInputType.text,
      controller: widget.controller,
      obscureText:   widget.isPasswordField ? showPass : false,
      decoration: boxContainer(widget.text!),
    );

  }


  InputDecoration boxContainer(String text) {
    var colorText =borderColor;

    return InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
        widget.isPasswordField?
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: (){
              setState(() {
                showPass = !showPass;
              });
            },
            child: Icon(
              showPass
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
            ),
          ),)
        :null,
        filled: true,
        fillColor: Colors.transparent,
        hintText: text,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Controller.roundCorner),
            borderSide:  BorderSide(
                color: colorText, width: 1.0)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Controller.roundCorner),
            borderSide:  BorderSide(
                color: colorText,
                width: 1.0)
        )


    )

    ;
  }
}
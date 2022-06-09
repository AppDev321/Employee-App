import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioInspectionCheck extends StatefulWidget {
  List<String> questions;

  RadioInspectionCheck(this.questions);

  @override
  RadioInspectionCheckState createState() => RadioInspectionCheckState();
}

class RadioInspectionCheckState extends State<RadioInspectionCheck> {
  int groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        widget.questions.length,
            (int i) => Radio<int>(
          value: i,
          groupValue: groupValue,
          onChanged: _handleRadioValueChange(i),
        ),
      ),
    );
  }

   _handleRadioValueChange(int value) {
    setState(() {
      groupValue = value;
    });
  }
}
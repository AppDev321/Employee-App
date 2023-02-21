import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  FlatButton({Key? key, required this.text, this.color, required this.callback})
      : super(key: key);
  String text;
  Color? color;
  ValueChanged<bool> callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback(true);
      },
      child: Container(child: Text(text)),
    );
  }
}

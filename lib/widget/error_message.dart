import 'package:flutter/material.dart';
import '../custom_style/text_style.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    Key? key,
    required this.label
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          '$label',
          textAlign: TextAlign.center,
          textScaleFactor: 1.3,
          style: errorTextStyle,
        ));
  }
}

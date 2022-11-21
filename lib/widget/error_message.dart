import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import '../custom_style/text_style.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    Key? key,
    required this.label,
    this.color = Colors.black54
  }) : super(key: key);

  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            CustomTextWidget(text: label,size: 22,color:color ,fontWeight: FontWeight.w200,textAlign: TextAlign.center,));
  }
}

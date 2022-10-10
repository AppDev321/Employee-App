import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_radio_check.dart';

class RadioItem {
  String? name;
  int? index;

  RadioItem(String name, int index) {
    this.name = name;
    this.index = index;
  }
}

class CustomRadioGroupWidget extends StatefulWidget {
   const CustomRadioGroupWidget(
      {required this.initialIndex,
      required this.items,
      required this.onValueChange});

  final int initialIndex;
  final List<RadioItem> items;
  final void Function(RadioItem) onValueChange;

  @override
  State createState() => CustomRadioGroupWidgetState();
}

class CustomRadioGroupWidgetState extends State<CustomRadioGroupWidget> {
  var flist = [];
  late var radioItem;

  @override
  void initState() {
    super.initState();
    flist = widget.items;
    radioItem = flist[widget.initialIndex];
  }

  Widget build(BuildContext context) {
    return Column(
      children: flist
          .map((data) => LabeledRadio<RadioItem>(
                label: "${data.name}",
                padding: EdgeInsets.all(2),
                value: data,
                groupValue: radioItem,
                onChanged: (RadioItem val) {

                  widget.onValueChange(val);
                  setState(() {
                    radioItem = val;

                  });
                },
              ))
          .toList(),
    );
  }
}

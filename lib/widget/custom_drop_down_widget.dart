import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';
import '../repository/model/response/leave_list.dart';

class CustomDropDownWidget extends StatefulWidget {

  List<DropMenuItems> spinnerItems ;
  final ValueChanged<DropMenuItems>? onClick;
  final TextEditingController? controller;

  CustomDropDownWidget({Key? key, this.onClick = null, this.controller = null,required this.spinnerItems})
      : super(key: key);

  @override
  _CustomDropMenuWidget createState() => _CustomDropMenuWidget();
}

class _CustomDropMenuWidget extends State<CustomDropDownWidget> {
  bool showPass = false;
  DropMenuItems? dropdownValue ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dropdownValue = widget.spinnerItems[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: DropdownButton<DropMenuItems>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 16),
            underline: SizedBox(),
            onChanged: (data) {
              setState(() {
                dropdownValue = data!;
              });
              widget.onClick!(dropdownValue!);

            },
            items: widget.spinnerItems.map((DropMenuItems f) {

              return new DropdownMenuItem<DropMenuItems>(
                value: f,
                child: CustomTextWidget(text:f.name),
              );
            }).toList(),
          ),
        ),
      ]),
    );
  }
}

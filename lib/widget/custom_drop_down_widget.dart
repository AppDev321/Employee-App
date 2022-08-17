import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';
import '../repository/model/response/leave_list.dart';
import '../utils/controller.dart';

class CustomDropDownWidget extends StatefulWidget {

  List<DropMenuItems> spinnerItems ;
  final ValueChanged<DropMenuItems>? onClick;
  final TextEditingController? controller;
  final bool fullWidth;

  CustomDropDownWidget({Key? key,
    this.onClick = null,
    this.controller = null
    ,required this.spinnerItems,
    this.fullWidth = true,

  })
      : super(key: key);

  @override
  _CustomDropMenuWidget createState() => _CustomDropMenuWidget();
}

class _CustomDropMenuWidget extends State<CustomDropDownWidget> {
  bool isFullWidth =true;
  DropMenuItems? dropdownValue ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      dropdownValue = widget.spinnerItems[0];
      isFullWidth = widget.fullWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(

          mainAxisSize: MainAxisSize.max,

          children: [

            isFullWidth ?
        Expanded(
          child: Container(

            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                border: Border.all(color:textFielBoxBorderColor, width: 1),
                borderRadius: BorderRadius.circular(Controller.roundCorner)),
            child:
            DropdownButton<DropMenuItems>(
              isExpanded: true,
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
        )
            :
            Container(

                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    border: Border.all(color:textFielBoxBorderColor, width: 1),
                    borderRadius: BorderRadius.circular(Controller.roundCorner)),
                child:
                DropdownButton<DropMenuItems>(
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

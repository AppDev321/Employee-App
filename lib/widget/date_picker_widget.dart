import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../custom_style/colors.dart';
import '../utils/controller.dart';

class DatePickerWidget extends StatefulWidget {

   DatePickerWidget({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateChange,
  }) : super(key: key);

  final String label;
  DateTime selectedDate ;
  final ValueChanged<DateTime> onDateChange;


  @override
  _DateWidget createState() => _DateWidget();
}

class _DateWidget extends State<DatePickerWidget> {
  late DateTime selectedDate = widget.selectedDate;


  @override
  Widget build(BuildContext context) {
    var colorText =!Get.isDarkMode?blackThemeTextColor:textFielBoxBorderColor;

    return  Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,

         children: [
          CustomTextWidget(text: widget.label,fontWeight: FontWeight.bold,),
          SizedBox(height: 10,),
          Row(
         mainAxisSize: MainAxisSize.max,
            children:[
              Container(
                  width: MediaQuery.of(context).size.width/2.3,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: 5, right: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: colorText, width: 1),
                    borderRadius: BorderRadius.circular(Controller.roundCorner)),
                child: new InkWell(

                    onTap: () {
                      _selectDate(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
                      children: [
                        CustomTextWidget(text: selectedDate ==  null  ? 'No date was chosen!'  : Controller().getConvertedDate(selectedDate)),

                       IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),

                      ],
                    )))],
          ),
        ]),

    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2035),
    );
    if (selected != null && selected !=selectedDate)
      {
        setState(() {
          selectedDate = selected;
          build(context);
          widget.onDateChange(selectedDate);
        });

      }


    // Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
  }

}

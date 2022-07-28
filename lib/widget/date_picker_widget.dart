import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

class DatePickerWidget extends StatelessWidget {

  const DatePickerWidget({
    Key? key,
    required this.label,
    required this.selectedDate,
    required this.onDateChange
  }) : super(key: key);

  final String label;
 final  DateTime selectedDate ;
  final ValueChanged<String> onDateChange;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
   children: [
        CustomTextWidget(text: label),
        SizedBox(height: 10,),
        Row(
       mainAxisSize: MainAxisSize.min,
          children:[
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                  left: 5, right: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              child: new InkWell(

                  onTap: () {
                    _selectDate(context);
                  },
                  child: Row(

                    children: [
                      CustomTextWidget(text: selectedDate ==  null  ? 'No date was chosen!'  : "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                      const SizedBox(width: 10),
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
    if (selected != null && selected != selectedDate)
      {
        var dateSelected = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
          onDateChange(dateSelected);
      }


    // Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
  }

}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateRangeWidget extends StatelessWidget
{

   CustomDateRangeWidget({
    Key? key,
    required this.controllerDate,
    required this.onDateChanged,
     required this.onFetchDates,
     this.isSearchButtonShow = false


  })  :
        super(key: key);


   final ValueChanged<Map> onFetchDates;
  final ValueChanged<Map> onDateChanged;
  final String labelText =DateFormat.yMMMEd().format(DateTime.now());
   final bool isSearchButtonShow;
  final TextEditingController controllerDate;
   DateTime end = DateTime(  DateTime.now().year, DateTime.now().month, DateTime.now().day + 7);
  DateTime start = DateTime.now();

  @override
  Widget build(BuildContext context) {
   return Column(

     children: [
        TextField(
          controller: controllerDate,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.date_range),
          suffixIcon: Icon(Icons.arrow_drop_down),
         hintText: labelText),
          onTap: () {
                       dateTimeRangePicker(context);
                },
          readOnly: true,
       ),

       isSearchButtonShow?
       Container(
         alignment: Alignment.bottomRight,
         child: ElevatedButton.icon(
           icon: Icon(Icons.search),
           label: Text("Search"),
           onPressed:() {
             if(start != null && end != null)
             {
               Map<String,DateTime> dates= {
                 "start": start,
                 "end":end,
               };
               onFetchDates(dates);
             }
           },
         )

       ):Center()

     ],
   );
  }




  dateTimeRangePicker(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: DateTimeRange(
        end: end,
        start: start,
      ),
    );

    if(picked != null) {
      end = picked.end;
      start = picked.start;
      Map<String,DateTime> dates= {
        "start": start,
        "end":end,
      };
      onDateChanged(dates);
      if(isSearchButtonShow == false)
        {
           onFetchDates(dates);

        }
    }

  }

}
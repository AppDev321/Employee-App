import 'package:flutter/material.dart';

class CustomDateRangeWidget extends StatelessWidget
{

   CustomDateRangeWidget({
    Key? key,
    this.labelText,
    required this.controllerDate,
    required this.onDateChanged,
     required this.onFetchDates,
     this.isSearchButtonShow = false


  })  :
        super(key: key);


   final ValueChanged<Map> onFetchDates;
  final ValueChanged<Map> onDateChanged;
  final String? labelText;
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
              border:const OutlineInputBorder(),
          prefixIcon:const Icon(Icons.date_range),
          suffixIcon:const Icon(Icons.arrow_drop_down),
          labelText:labelText,
          ),
          onTap: () {
                       dateTimeRangePicker(context);
                },
          readOnly: true,
       ),

       isSearchButtonShow?
       Container(
         alignment: Alignment.bottomRight,
         child: ElevatedButton.icon(
           icon:const Icon(Icons.search),
           label:const Text("Search"),
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

       ):const Center()

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
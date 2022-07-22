import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalanderWidget extends StatelessWidget {
  const CustomCalanderWidget(
      {Key? key, required this.controller, required this.onChanged})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final CalendarController controller;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      initialCalendarFormat: CalendarFormat.week,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(22.0),
        ),
        formatButtonTextStyle: TextStyle(color: Colors.white),
        formatButtonShowsNext: false,
        formatButtonVisible: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, events, holidays) {
        var formatter = new DateFormat('yyyy-MM-dd');

        String formattedDate = formatter.format(date);
        onChanged(formattedDate);
      },
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
        todayDayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
      ),
      calendarController: controller,
    );
  }
}

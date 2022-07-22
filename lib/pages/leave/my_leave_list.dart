import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/pages/leave/add_my_leave.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../custom_style/colors.dart';
import '../../custom_style/text_style.dart';

class MyLeaveList extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(ConstantData.attendence),
      ),
      body: Column(
        children: [
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20, top: 10),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                onPressed: () {

                  final navigateTo = (page) =>
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => page,
                      ));
                  navigateTo(AddMyLeave());



                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueAccent),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 12))),
                label: Text('Add Leave'),
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: _containerLeave(context),
          )
        ],
      ));

  Widget _containerLeave(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(170),
          1: FlexColumnWidth(),
        },
        children: [
          createRowWithBorder("Leave Type", "type"),
          createRowWithBorder("Leave Type", "type"),
          createRowWithBorder("Leave Type", "type"),
          createRowWithBorder("Leave Type", "type"),
          createStatusRow("Status"),
          createRowButtonWithBorder("Action")
        ],
        border: TableBorder.symmetric(inside: BorderSide(width: 1)),
      ),
    );
  }

  TableRow createRowWithBorder(String title, String value) {
    return TableRow(children: [
      Container(
          padding: const EdgeInsets.all(15),
          child: Text(title, style: normalBoldTextStyle)),
      Container(
          color: inspectionTableColor,
          padding: const EdgeInsets.all(15),
          child: Text(value, style: normalTextStyle)),
    ]);
  }

  TableRow createStatusRow(String title) {
    return TableRow(children: [
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(15),
              child: Text(title, style: normalBoldTextStyle))),
      TableCell(
          child: Container(
              color: inspectionTableColor,
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Wrap(children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 12))),
                      child: Text('Approved'),
                    )
                  ])
                ],
              ))),
    ]);
  }

  TableRow createRowButtonWithBorder(  String title) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.fill,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(15),
            child: Text(title, style: normalBoldTextStyle)),
      ),
      TableCell(
        child: Container(
            color: inspectionTableColor,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Wrap(children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.preview),
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 12))),
                    label: Text('View'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 12))),
                    label: Text('Delete'),
                  )
                ])
              ],
            )),
      )
    ]);
  }
   void _onDaySelected(DateTime day, List events) {
     print('CALLBACK: _onDaySelected');

   }

}

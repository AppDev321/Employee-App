import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/strings.dart';

class AddMyLeave extends StatelessWidget {
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
                onPressed: () {},
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
    return Column(children: [
      Text(
        "Details",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        "Create checkIn/checkOut",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        "Select Leave Type",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "From Date",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "To Date",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "Subject",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "Is Delay?:",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "Total hour:",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Text(
        "Total checks:",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Container(
        width: 348,
        height: 1,
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Text(
        "Select leave type",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Text(
        "mm/dd/yy",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Text(
        "mm/dd/yy ",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Text(
        "Type Subject",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Container(
        width: 10,
        height: 9.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: FlutterLogo(size: 9.21875),
      ),
      Container(
        width: 10,
        height: 9.22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: FlutterLogo(size: 9.21875),
      ),
      Transform.rotate(
        angle: 1.57,
        child: Container(
          width: 5,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: Color(0x7f7f3a44),
          ),
        ),
      ),
      Text(
        "Description",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Container(
        width: 317,
        height: 94,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Text(
        "Select name here",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Text(
        "Select name here",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Transform.rotate(
        angle: 1.57,
        child: Container(
          width: 5,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: Color(0x7f7f3a44),
          ),
        ),
      ),
      Text(
        "Backup/ Point of contact",
        style: TextStyle(
          color: Colors.black,
          fontSize: 13,
        ),
      ),
      Container(
        width: 317,
        height: 47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
          color: Colors.white,
        ),
      ),
      Text(
        "Select name here",
        style: TextStyle(
          color: Color(0x5e000000),
          fontSize: 13,
        ),
      ),
      Transform.rotate(
        angle: 1.57,
        child: Container(
          width: 5,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
            color: Color(0x7f7f3a44),
          ),
        ),
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/pages/vehicleInspection/vehicle_inspection_list.dart';
import 'package:hnh_flutter/view_models/vehicle_inspection_list_vm.dart';
import 'package:provider/provider.dart';


class CreateInspection extends StatelessWidget {

  int _vehicleID = 0;
  String title;
  final VoidCallback onCountSelected;
  CreateInspection(this.title,this._vehicleID ,this.onCountSelected) ;



  final TextEditingController _emailController = TextEditingController();
  String date = "";
  DateTime selectedDate = DateTime.now();

  List <String> spinnerItems = [
    'Select inspection type',
    'initial-safety-inspection',
    'weekly-safety-check',
    'pre-mot-inspection'
  ] ;

  String dropdownValue = 'Select inspection type';
 // initial-safety-inspection,weekly-safety-check,pre-mot-inspectio
  @override
  Widget build(BuildContext context) {
    return
      Expanded(
      child:
          SingleChildScrollView
            (
            child: Column(
              children: [
               /* Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(20),
                    child: Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))),*/



                Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                    child:Expanded(
                        child:  Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Inspection Information",style: TextStyle(
                                  fontSize: 16
                              ),),
                            ),
                            SizedBox(height: 10),
                            Divider(
                                color: Colors.black
                            ),
                            SizedBox(height: 5),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Inspection Type *",style: TextStyle(
                                  fontSize: 14
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                  children:
                                  [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black,width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: DropdownButton<String>(
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black, fontSize: 16),
                                        underline: SizedBox(),
                                        onChanged: (data){
                                          dropdownValue=data!;
                                          print('$data');
                                        },
                                        items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Inspection Date *",style: TextStyle(
                                  fontSize: 14
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                  children:
                                  [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black,width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:
                                      ElevatedButton(
                                        onPressed: () {
                                          _selectDate(context);
                                        },
                                        child: Text("Choose Date"),
                                      ),

                                    ),
                                  ]
                              ),

                            ),


                            SizedBox(height: 15),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Inspection Date *",style: TextStyle(
                                  fontSize: 14
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child:
                              TextField(
                                controller: _emailController,
                                decoration:  InputDecoration(
                                    filled: true,
                                    fillColor: textFielBoxFillColor,
                                    hintText: 'Enter Odo Reading',
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: textFielBoxBorderColor, width: 1.0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: textFielBoxBorderColor,
                                            width: 1.0))),
                              ),

                            ),
                          ],
                        )
                    )
                ),
            SizedBox(height: 20,),
                Container(

                    padding: EdgeInsets.only(left: 15,bottom: 10),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Container(
                          width: 150,
                          child: ElevatedButton(
                          onPressed:
                              () {
                            onCountSelected();
                            // Provider.of<VehicleInspectionListViewModel>(context,listen: false).setInspectionViewStatus(false);

                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey),
                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12))),
                          child: Text('Cancel'),
                      ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            onPressed:
                                () {
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue),
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12))),
                            child: Text('Create'),
                          ),
                        ),
                        ]
                    )
                ),
              ],

            )
          )




      );
  }
  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
     // setState(() {
        selectedDate = selected;
     // });

   // Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),

  }
}
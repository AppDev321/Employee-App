import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/data/drawer_items.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/response/leave_list.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../repository/model/request/availability_request.dart';
import '../../utils/controller.dart';
import '../../view_models/availability_vm.dart';
import '../../view_models/leave_list_vm.dart';
import '../../widget/custom_comment_box.dart';
import '../../widget/custom_drop_down_widget.dart';
import '../../widget/date_picker_widget.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/internet_not_available.dart';

class ViewAvailability extends StatefulWidget {
  final AvailabilityRequest? availabilityRequest;
  final bool? isEditableView;

  const ViewAvailability({Key? key,this.availabilityRequest,this.isEditableView })
      : super(key: key);

  @override
  State<ViewAvailability> createState() => ViewAvailabilityStateful();
}

class ViewAvailabilityStateful extends State<ViewAvailability> {
  String? _errorMsg = "";

  TextEditingController subjectController = TextEditingController();
  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  late AvailabilityViewModel _availabilityViewModel;
  DialogBuilder? _progressDialog;
  int leaveTypeId = 1;
  BuildContext? _dialogContext;
  List<DropMenuItems> dropMenuItem = [
    DropMenuItems(id: 0, name: "Today Ownward"),
    DropMenuItems(id: 1, name: "Specific Dates"),
  ];

  bool isEffectiveDate = false;
  bool isAllDay = true;


  List<DropMenuItems> dropDays = [
    DropMenuItems(id: 0, name: "Monday"),
    DropMenuItems(id: 1, name: "Tuesday"),
    DropMenuItems(id: 2, name: "Wednesday"),
    DropMenuItems(id: 3, name: "Thursday"),
    DropMenuItems(id: 4, name: "Friday"),
    DropMenuItems(id: 5, name: "Saturday"),
    DropMenuItems(id: 6, name: "Sunday"),
  ];

  List<DropMenuItems> hours = [
    DropMenuItems(id: 0, name: "00"),
    DropMenuItems(id: 1, name: "01"),
    DropMenuItems(id: 2, name: "02"),
    DropMenuItems(id: 3, name: "03"),
    DropMenuItems(id: 4, name: "04"),
    DropMenuItems(id: 5, name: "05"),
    DropMenuItems(id: 6, name: "06"),
    DropMenuItems(id: 7, name: "07"),
    DropMenuItems(id: 8, name: "08"),
    DropMenuItems(id: 9, name: "09"),
    DropMenuItems(id: 10, name: "10"),
    DropMenuItems(id: 11, name: "11"),
    DropMenuItems(id: 12, name: "12"),
    DropMenuItems(id: 13, name: "13"),
    DropMenuItems(id: 14, name: "14"),
    DropMenuItems(id: 15, name: "15"),
    DropMenuItems(id: 16, name: "16"),
    DropMenuItems(id: 17, name: "17"),
    DropMenuItems(id: 18, name: "18"),
    DropMenuItems(id: 19, name: "19"),
    DropMenuItems(id: 20, name: "20"),
    DropMenuItems(id: 21, name: "21"),
    DropMenuItems(id: 22, name: "22"),
    DropMenuItems(id: 23, name: "23"),
  ];

  List<DropMenuItems> minutes = [
    DropMenuItems(id: 0, name: "00"),
    DropMenuItems(id: 1, name: "15"),
    DropMenuItems(id: 2, name: "30"),
    DropMenuItems(id: 3, name: "45"),
  ];

  List<TimeSlot> timeList = [];

  String startTime = "", start_hour = "00", start_minute = "00";
  String endTime = "", end_hour = "00", end_minute = "00";
  String dayName = "mon";

  bool isEditableView = false ;
  late  AvailabilityRequest availabilityRequest;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _availabilityViewModel = AvailabilityViewModel();

    _availabilityViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();

      var checkErrorApiStatus = _availabilityViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _errorMsg = _availabilityViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
          }
        });
      } else {
        if (_availabilityViewModel.getRequestStatus()) {
          setState(() {
            _errorMsg = "";
          });

          Controller()
              .showToastMessage(
              context, "Request submitted successfully");
          Navigator.pop(context);
        }
        else
          {
            _errorMsg = _availabilityViewModel.getErrorMsg();
            if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
              Controller().logoutUser();
            } else {
              Controller().showToastMessage(context, _errorMsg!);
            }
          }
      }
    });



    if(widget.availabilityRequest != null)
      {
        availabilityRequest = widget.availabilityRequest!;
        timeList = widget.availabilityRequest!.timeSlot!;
        isEditableView = widget.isEditableView!;
        subjectController.text = availabilityRequest.title.toString();
      }


  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    if (_progressDialog == null) {
      _progressDialog = DialogBuilder(_dialogContext!);
      _progressDialog?.initiateLDialog('Please wait..');
    }


    var startEffectDate =Controller().getServerDateFormated(availabilityRequest.startDate!) ;

    var endEffectDate = "";
    if(availabilityRequest.endDate != null)
    {
      endEffectDate=Controller().getServerDateFormated(availabilityRequest.endDate!);
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text(availability),
      ),
      body:

      Column(
        children: [
          BlocBuilder<ConnectedBloc, ConnectedState>(
              builder: (context, state) {
                if (state is ConnectedFailureState) {
                  return InternetNotAvailable();
                } else {
                  return Container();
                }
              }),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextWidget(text: isEditableView? "Availability Request" : "Request Detail", size: 25),
                    const SizedBox(
                      height: 20,
                    ),
                    isEditableView ?
                    CustomCommentBox(
                        label: "Title",
                        hintMessage: "E.g Summer Holiday Availability",
                        controller: subjectController):
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                          CustomTextWidget(text: "Title", fontWeight: FontWeight.bold,),
                          CustomTextWidget(text: availabilityRequest.title, ),
                        ]),
                    const SizedBox(
                      height: 20,
                    ),


                    isEditableView ?Column(
                      children:[
                        const CustomTextWidget(
                          text: "Effective Dates:",
                          fontWeight: FontWeight.bold,
                        ),
                        CustomDropDownWidget(
                          spinnerItems: dropMenuItem,
                          onClick: (data) {
                            if (data.id == 1) {
                              setState(() {
                                isEffectiveDate = true;
                              });
                            } else {
                              setState(() {
                                isEffectiveDate = false;
                              });
                            }
                          },
                        ),
                        isEffectiveDate
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DatePickerWidget(
                              selectedDate: DateTime.now(),
                              label: "From Date",
                              onDateChange: (value) {
                                setState(() {
                                  startDate = value;
                                });
                              },
                            ),
                            DatePickerWidget(
                              selectedDate: DateTime.now(),
                              label: "To Date",
                              onDateChange: (value) {
                                setState(() {
                                  endDate = value;
                                });
                              },
                            ),
                          ],
                        )
                            : Container(),

                      ]
                    ):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const CustomTextWidget(text: "Effective Date:",fontWeight: FontWeight.bold,),
                        const SizedBox(height: 5,),
                        Row(children: [
                        endEffectDate.isEmpty ?
                        CustomTextWidget(text: startEffectDate )
                        : CustomTextWidget(text: "$startEffectDate to $endEffectDate"),
                        ],)

                      ]
                  ),


                    const SizedBox(
                      height: 20,
                    ),

                    showAvailabilityBox( isEditableView ),

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: 12))),
                              child: Text('Cancel'),
                            ),
                          ),
                          isEditableView ? const SizedBox(
                            width: 30,
                          ):const Center(),
                          isEditableView ?
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_datesCheck()) {
                                  _progressDialog?.showLoadingDialog();
                                  var request = AvailabilityRequest();
                                  request.startDate = Controller().getConvertedDate(startDate);
                                  if(!isEffectiveDate)
                                    {
                                      request.endDate = "";
                                    }
                                  else
                                    {
                                      request.endDate = Controller().getConvertedDate(endDate);
                                    }
                                  request.title = subjectController.text;
                                  request.timeSlot = timeList;
                                  _availabilityViewModel.saveAvailabilityRequest(request);
                                } else {
                                  Controller().showToastMessage(context,
                                      "End date must be greater than leave start date");
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor),
                                  textStyle: MaterialStateProperty.all(
                                      const TextStyle(fontSize: 12))),
                              child: const Text('Save'),
                            ),
                          ):const Center()
                          ,
                        ]),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _datesCheck() {
    if (endDate.isAfter(startDate) || endDate == startDate) {
      return true;
    } else {
      return false;
    }
  }

  Widget showAvailabilityBox(bool  isEditableView ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextWidget(
          text: "Availability:",
          fontWeight: FontWeight.bold,
        ),

        isEditableView ? CustomDropDownWidget(
          spinnerItems: dropDays,
          onClick: (data) {
            dayName = data.name.toString().substring(0,3).toLowerCase();
          },
        ):const Center(),


        const SizedBox(
          height: 5,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            return timeListRow(timeList[index],isEditableView);
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timeList.length,
        ),
        isEditableView ?  Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Controller.roundCorner),
          ),
          child: Column(
            children: [
              CheckboxListTile(
                checkColor: Colors.white,
                activeColor:primaryColor,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('All Day'),
                value: isAllDay,
                onChanged: (value) {
                  setState(() {
                    isAllDay = value!;
                  });
                },
              ),



              !isAllDay
                  ? Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CustomTextWidget(
                              text: "From",
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: CustomDropDownWidget(
                                spinnerItems: hours,
                                fullWidth: false,
                                onClick: (data) {
                                  start_hour = data.name.toString();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: CustomDropDownWidget(
                                spinnerItems: minutes,
                                fullWidth: false,
                                onClick: (data) {
                                  start_minute = data.name.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const CustomTextWidget(
                              text: "To",
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: CustomDropDownWidget(
                                spinnerItems: hours,
                                fullWidth: false,
                                onClick: (data) {
                                  end_hour = data.name.toString();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: CustomDropDownWidget(
                                spinnerItems: minutes,
                                fullWidth: false,
                                onClick: (data) {
                                  end_minute = data.name.toString();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),




              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      setState(() {
                        saveTimeSlots(true);
                      });
                    },
                    child: const Text('Available'),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      setState(() {
                        saveTimeSlots(false);
                      });
                    },
                    child: const Text('Unavailable'),
                  )),
                ],
              ),
            ],
          ),
        ):const Center(),
      ],
    );
  }

  saveTimeSlots(bool isAvailableTime) {
    int startHour = int.parse(start_hour);
    int endHour = int.parse(end_hour);

    bool isEntryAllow=true;

    var savedTimeSlot = new TimeSlot();


    for (int i = 0; i < timeList.length; i++) {
      var itemData= timeList[i];
        if(itemData.dayName == dayName)
        {
          int storedStartHour = int.parse(itemData.startHour.toString());
          int storedEndHour = int.parse(itemData.endHour.toString());

          if(
              (startHour >= storedStartHour  && startHour <= storedEndHour)
                  ||
              (startHour < storedStartHour && startHour <= storedEndHour)
          )
          {       //New row created
             isEntryAllow = false;
             savedTimeSlot= itemData;
             if (isAvailableTime == savedTimeSlot.isAvailable) {
               timeList.remove(itemData);
             }
           }

          else
            {
              isEntryAllow =true;

            }

        }

    }


    if(isEntryAllow) {
      startTime = "$start_hour:$start_minute";
      endTime = "$end_hour:$end_minute";

      var timeAdd = TimeSlot();
      timeAdd.end = endTime;
      timeAdd.start = startTime;
      timeAdd.isAvailable = isAvailableTime;
      timeAdd.dayName = dayName;
      timeAdd.isAllDay = false;

      timeAdd.startHour = start_hour;
      timeAdd.startMinute = start_minute;
      timeAdd.endMinute = end_minute;
      timeAdd.endHour = end_hour;

      if (isAllDay) {
        timeAdd.isAllDay = true;
        timeList.add(timeAdd);

        start_hour = "00";
        start_minute ="00";
        end_hour ="00";
        end_minute="00";

      } else if (endHour == 0 && startHour == 0) {
        timeAdd.isAllDay = true;
        timeList.add(timeAdd);

        start_hour = "00";
        start_minute ="00";
        end_hour ="00";
        end_minute="00";


      } else if (endHour <= startHour) {
        Controller().showToastMessage(
            context, "Time must be at least one hour ");
      } else {
        timeList.add(timeAdd);
      }
    }
    else {
      if (isAvailableTime == savedTimeSlot.isAvailable) {
        int storedStartHour = int.parse(savedTimeSlot.startHour.toString());
        int storedEndHour = int.parse(savedTimeSlot.endHour.toString());


        if ((startHour >= storedStartHour && startHour <= storedEndHour) ||
            (startHour < storedStartHour && startHour <= storedEndHour)
        ) {
          if (startHour < 10) {
            savedTimeSlot.startHour = "0$startHour";
          } else {
            savedTimeSlot.startHour = startHour.toString();
          }

          if (endHour < 10) {
            savedTimeSlot.endHour = "0$endHour";
          }
          else {
            savedTimeSlot.endHour = endHour.toString();
          }
        }

        var timeAdd = TimeSlot();
        startTime = "${savedTimeSlot.startHour}:${savedTimeSlot.startMinute}";
        endTime = "${ savedTimeSlot.endHour }:${ savedTimeSlot.endMinute}";

        timeAdd.end = endTime;
        timeAdd.start = startTime;
        timeAdd.isAvailable = isAvailableTime;
        timeAdd.dayName = dayName;
        timeAdd.isAllDay = savedTimeSlot.isAllDay;

        timeAdd.startHour = start_hour;
        timeAdd.startMinute = start_minute;
        timeAdd.endMinute = end_minute;
        timeAdd.endHour = end_hour;
        //    timeList.add(timeAdd);


        if (isAllDay) {
          timeAdd.isAllDay = true;
          timeList.add(timeAdd);

          start_hour = "00";
          start_minute ="00";
          end_hour ="00";
          end_minute="00";


          timeList.remove(savedTimeSlot);



        } else if (endHour == 0 && startHour == 0) {
          timeAdd.isAllDay = true;
          timeList.add(timeAdd);

          start_hour = "00";
          start_minute ="00";
          end_hour ="00";
          end_minute="00";

          timeList.remove(savedTimeSlot);




        } else if (endHour <= startHour) {
          Controller().showToastMessage(
              context, "Time must be at least one hour ");
        } else {
          timeList.add(timeAdd);
          timeList.remove(savedTimeSlot);
        }
      }

    else
      {
        Controller().showToastMessage(
            context, "This time slot is not allowed because its already booked in ${savedTimeSlot.isAvailable! ? "Available" : "Unavailable"} slot." );
      }
    }
  }

  Widget timeListRow(TimeSlot item,bool isEditableView) {
    var color = item.isAvailable! ? Colors.green : Colors.red;
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Controller.roundCorner),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item.isAllDay!
              ? CustomTextWidget(
                  text: "${item.dayName.toString().toUpperCase()} ${item.isAvailable!
                      ? "All Day Available"
                      : "All Day Unavailable"}",
                  color: color,
                  fontWeight: FontWeight.bold,
                )
              : Row(
                  children: [
                    CustomTextWidget(
                      text: item.dayName.toString().toUpperCase(),
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomTextWidget(
                      text: "${item.start} - ${item.end}",
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
          isEditableView?
          IconButton(
            onPressed: () {
              setState(() {
                timeList.remove(item);
              });
            },
            icon: Icon(
              Icons.close,
              color: color,
            ),
          ):const Center()
        ],
      ),
    );
  }
}


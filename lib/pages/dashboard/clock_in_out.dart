import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/view_models/dashbboard_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:intl/intl.dart';

import '../../custom_style/colors.dart';
import '../../repository/model/response/report_attendance_response.dart';
import '../../utils/controller.dart';
import '../../view_models/reports_vm.dart';
import '../attandence/add_attendance.dart';


class ClockInOutWidget extends StatefulWidget {
  final Attendance attendanceItem;
  final bool isCheckOut;
   ClockInOutWidget({Key? key,required this.attendanceItem,this.isCheckOut = true}) : super(key: key);


  @override
  ClockInOutWidgetState createState() => ClockInOutWidgetState();
}

class ClockInOutWidgetState extends State<ClockInOutWidget> {
  String timeCounter = "";
  late Attendance attendance;
  final NavigatorKey = GlobalKey<NavigatorState>();

  // bool isCheckIn=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    attendance = widget.attendanceItem;

    if(attendance.timeOut!.isEmpty) {
      getTimeDiff(attendance.timeIn!);
    }

    return listItem(attendance);
  }

  Widget listItem(Attendance item) {
    ReportsViewModel reportsViewModel = ReportsViewModel();
    return Card(
        color: claimedShiftApprovedColor,
        elevation: 5,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Controller.roundCorner),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
            decoration: BoxDecoration(
                color: cardThemeBaseColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          color: Get.isDarkMode
                              ? primaryColor
                              : HexColor.fromHex("#dff4d8"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextWidget(
                                text: reportsViewModel.convertStringDate(
                                    item.date.toString(), "day"),
                                color: HexColor.fromHex("#7da36a"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextWidget(
                                text: reportsViewModel.convertStringDate(
                                    item.date.toString(), "date"),
                                fontWeight: FontWeight.bold,
                                color: HexColor.fromHex("#99cc60"),
                                size: 28,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextWidget(
                                text:
                                    "${reportsViewModel.convertStringDate(item.date.toString(), "month")}, ${reportsViewModel.convertStringDate(item.date.toString(), "year")}",
                                color: HexColor.fromHex("#7da36a"),
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ))),
                  Expanded(
                      flex: 3,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Icon(
                                            Icons.assignment_turned_in_outlined,
                                            size: 15.0,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const CustomTextWidget(
                                            text: "Check In",
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: CustomTextWidget(
                                            text: item.timeIn?.isEmpty==true ?"--/--":item.timeIn,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: const [
                                          Icon(
                                            Icons.assignment_turned_in_outlined,
                                            size: 15.0,
                                            color: claimedShiftColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          CustomTextWidget(
                                            text: "Check Out",
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                     Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: CustomTextWidget(
                                              text:
                                                  item.timeOut?.isEmpty == true
                                                      ? "--/--"
                                                      : item.timeOut,
                                              fontWeight: FontWeight.bold,
                                              color: claimedShiftColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // MaterialButton(child: Text("data"),
                                  //     onPressed: (){Get.to(() =>  MarkedAttendanceDetails(summaryItem: attendance.summary!));
                                  // }),
                                  item.summary != null
                                      ? IconButton(
                                          onPressed: () {
                                          reportsViewModel.showBottomSheet(
                                                context, item.summary!);
                                          },
                                          icon: const Icon(Icons.more_vert))
                                      : const Center()
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      Icon(
                                        Icons.timelapse_outlined,
                                        size: 15.0,
                                        color: HexColor.fromHex("#7da36a"),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: CustomTextWidget(
                                          text: item.timeOut!.isEmpty
                                              ? timeCounter
                                              :reportsViewModel. durationToString(item!.totalTime!),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(
                                    child:
                                    ElevatedButton.icon(
                                      onPressed: () => Get.to(() => AddAttendance(
                                            attendanceType:
                                                widget.isCheckOut ? 1 : 0,
                                          )
                                      ),

                                      icon: const Icon(Icons.qr_code_outlined),
                                      label: Text(widget.isCheckOut
                                          ? "Check Out"
                                          : "Check In"), //label text
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))),
                ],
              ),
            )));
  }
 getTimeDiff(String checkIn)
{
  Timer.periodic(
    const Duration(seconds: 1),
        (timer) {
          DateFormat dateFormat =  DateFormat.Hm();
          DateTime now = DateTime.now();
          DateTime open = dateFormat.parse(checkIn);
        open = DateTime(now.year, now.month, now.day, open.hour, open.minute);
        if (mounted) {
          setState(() {
            timeCounter = calculateDuration(now.difference(open));
          });
        }
      },
    );
  }

  String calculateDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

}

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/response/report_attendance_response.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../utils/controller.dart';
import '../../view_models/reports_vm.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  State<AttendanceReport> createState() => AttendanceReportStateful();
}

class AttendanceReportStateful extends State<AttendanceReport> {
  int buttonState = 0;
  final TextEditingController _dateFilterController = TextEditingController();

  // List<String> months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Nov","Dec"];
  //List<String> years = ["2018","2019","2020","2021","2022","2023","2024","2024"];

  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";

  late ReportsViewModel _reportsViewModel;
  List<Attendance> attendanceList = [];
  Attendance? attendance = null;
  var request = ClaimShiftHistoryRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _reportsViewModel = ReportsViewModel();

    //Getting current month and date time
    DateTime now = DateTime.now();
    var startDate = DateTime(now.year, now.month, 1);
    var endDate = DateTime(now.year, now.month + 1, 0); //this month last date

    request = ClaimShiftHistoryRequest();
    request.start_date = Controller().getConvertedDate(startDate);
    request.end_date = Controller().getConvertedDate(endDate);

    _reportsViewModel.getAttendanceReport(request);

    _reportsViewModel.addListener(() {
      var checkErrorApiStatus = _reportsViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _reportsViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
          attendanceList = _reportsViewModel.attandenceList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(menuReport),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            BlocBuilder<ConnectedBloc, ConnectedState>(
                builder: (context, state) {
              if (state is ConnectedSucessState) {
                return Container();
              } else if (state is FirebaseMsgReceived) {
                return Container();
              } else {
                return const InternetNotAvailable();
              }
            }),
            const Padding(
              padding: EdgeInsets.all(20),
              child: CustomTextWidget(
                text: subMenuReportAttandance,
                size: 20,
              ),
            ),
            AnimatedButtonBar(
              padding: const EdgeInsets.all(9),
              backgroundColor: cardThemeBaseColor,
              radius: 20,
              invertedSelection: true,
              children: [
                ButtonBarEntry(
                  onTap: () {
                    changeButtonState(0);
                  },
                  child: const CustomTextWidget(
                    text: 'This Month',
                    size: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonBarEntry(
                  onTap: () {
                    changeButtonState(1);
                  },
                  child: const CustomTextWidget(
                    text: 'Last Month',
                    size: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonBarEntry(
                  onTap: () {
                    changeButtonState(2);
                  },
                  child: const CustomTextWidget(
                    text: 'This Year',
                    size: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonBarEntry(
                  onTap: () {
                    changeButtonState(3);
                  },
                  child: const CustomTextWidget(
                    text: 'Custom',
                    size: 12,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: buttonState == 3
                    ? CustomDateRangeWidget(
                        onDateChanged: (date) {
                          String startDate =
                              Controller().getConvertedDate(date['start']);
                          String endDate =
                              Controller().getConvertedDate(date['end']);
                          _dateFilterController.text = "$startDate To $endDate";
                        },
                        onFetchDates: (date) {
                          setState(() {
                            _isFirstLoadRunning = true;
                            _isErrorInApi = false;
                          });
                          String startDate =
                              Controller().getConvertedDate(date['start']);
                          String endDate =
                              Controller().getConvertedDate(date['end']);

                          request = ClaimShiftHistoryRequest();
                          request.start_date = startDate;
                          request.end_date = endDate;
                          _reportsViewModel.getAttendanceReport(request);
                        },
                        controllerDate: _dateFilterController,
                        isSearchButtonShow: false,
                      )
                    : buttonState == 1
                        ? const Center()
                        : buttonState == 2
                            ? const Center()
                            : const Center()),
            _isFirstLoadRunning
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : _isErrorInApi
                    ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                    : Expanded(
                        flex: 1,
                        child: RefreshIndicator(
                          onRefresh: () =>
                              _reportsViewModel.getAttendanceReport(request),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  itemCount: attendanceList.length,
                                  itemBuilder: (context, index) =>
                                      listItem(attendanceList[index]))),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget listItem(Attendance item) {
    return Card(
        color: claimedShiftApprovedColor,
        elevation: 5,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Controller.roundCorner),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
            // width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: cardThemeBaseColor,
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                text: _reportsViewModel.convertStringDate(
                                    item.date.toString(), "day"),
                                color: HexColor.fromHex("#7da36a"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextWidget(
                                text: _reportsViewModel.convertStringDate(
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
                                    "${_reportsViewModel.convertStringDate(item.date.toString(), "month")}, ${_reportsViewModel.convertStringDate(item.date.toString(), "year")}",
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
                                            const EdgeInsets.only(left: 30.0),
                                        child: CustomTextWidget(
                                            text: item.timeIn?.isEmpty == true
                                                ? "--/--"
                                                : item.timeIn,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 30.0),
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
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.timelapse_outlined,
                                    size: 15.0,
                                    color: HexColor.fromHex("#7da36a"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  CustomTextWidget(
                                    text: _reportsViewModel
                                        .durationToString(item!.totalTime!),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ))),
                  item.summary != null
                      ? IconButton(
                          onPressed: () {
                            _reportsViewModel.showBottomSheet(
                                context, item.summary!);
                          },
                          icon: const Icon(Icons.more_vert))
                      : const Center()
                ],
              ),
            )));
  }

  void changeButtonState(int status) {
    setState(() {
      buttonState = status;
    });

    request = ClaimShiftHistoryRequest();
    DateTime now = DateTime.now();
    if (status == 0) {
      var startDate = DateTime(now.year, now.month, 1);
      var endDate = DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    } else if (status == 1) {
      var startDate = DateTime(now.year, now.month - 2, 1);
      var endDate = DateTime(now.year, now.month - 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    } else if (status == 2) {
      var startDate = DateTime(now.year, 1, 1);
      var endDate = DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }

    if (status < 3) {
      setState(() {
        _isFirstLoadRunning = true;
        _isErrorInApi = false;
        _reportsViewModel.getAttendanceReport(request);
      });
    }
  }
}

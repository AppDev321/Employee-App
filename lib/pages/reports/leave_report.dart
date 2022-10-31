import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/widget/pie_chart.dart';
import 'package:intl/intl.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../repository/model/response/report_leave_response.dart';
import '../../utils/controller.dart';
import '../../view_models/reports_vm.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';

class LeaveReport extends StatefulWidget {
  const LeaveReport({Key? key}) : super(key: key);

  @override
  State<LeaveReport> createState() => LeaveReportStateful();
}

class LeaveReportStateful extends State<LeaveReport> {
  int buttonState = 0;
  final TextEditingController _dateFilterController = TextEditingController();

// List<String> months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Nov","Dec"];
  //List<String> years = ["2018","2019","2020","2021","2022","2023","2024","2024"];

  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";

  late ReportsViewModel _reportsViewModel;
  List<ChartData> leaveData = [];
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
    var startDate =  DateTime(now.year, now.month, 1);
    var endDate =
         DateTime(now.year, now.month + 1, 0); //this month last date

  request = ClaimShiftHistoryRequest();
    request.start_date = Controller().getConvertedDate(startDate);
    request.end_date = Controller().getConvertedDate(endDate);

    _reportsViewModel.getLeaveResports(request);

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
          leaveData = _reportsViewModel.leaveData;
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
      body: Column(
        children: [
          BlocBuilder<ConnectedBloc, ConnectedState>(
              builder: (context, state) {
                if (state is ConnectedSucessState) {
                  return Container();
                } else if(state is FirebaseMsgReceived)
                {
                  return Container();
                } else {
                  return const InternetNotAvailable();
                }
              }

          ),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CustomTextWidget(
                    text: subMenuReportLeave,
                    size: 20,
                  ),
                ),
                AnimatedButtonBar(
                  padding:const EdgeInsets.all(9),
                  backgroundColor: cardThemeBaseColor,
                  radius: 20,
                  invertedSelection: true,
                  children: [

                    ButtonBarEntry(
                        onTap: () {
                          changeButtonState(0);
                        },
                        child:const Text('This Month')),
                    ButtonBarEntry(
                        onTap: () {
                          changeButtonState(1);
                        },
                        child:const Text('Last Month')),
                    ButtonBarEntry(
                        onTap: () {
                          changeButtonState(2);
                        },
                        child:const Text('This Year')),
                    ButtonBarEntry(
                        onTap: () {
                          changeButtonState(3);
                        },
                        child:const Text('Custom'))
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
                              _reportsViewModel.getLeaveResports(request);
                            },
                            controllerDate: _dateFilterController,
                            isSearchButtonShow: false,
                          )
                        : buttonState == 1
                            ?const Center()
                            : buttonState == 2
                                ?const Center()
                                :const Center()),
                _isFirstLoadRunning
                    ? const Expanded(child: Center(child: CircularProgressIndicator()))
                    : _isErrorInApi
                        ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                        : Expanded(
                          flex: 1,

                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                    children: [
                                      Container(
                                          child: PieChartWidget(
                                        chartData: leaveData,
                                      )),
                                      const SizedBox(height:10),
                                     GridView.builder(
                                              physics:const ScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                                      maxCrossAxisExtent: 200,
                                                      childAspectRatio: 3 / 2,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10),
                                              itemCount: leaveData.length,
                                              itemBuilder: (BuildContext ctx, index) {
                                                return   Card(
                                                  color:  colorArray[index],
                                                    elevation: 5,
                                                    shadowColor: cardShadow,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(Controller.roundCorner),
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    child:
                                                    Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        decoration: BoxDecoration(
                                                            color:cardThemeBaseColor,
                                                            borderRadius:const BorderRadius.only(
                                                                bottomRight: Radius.circular(Controller.roundCorner),
                                                                topRight: Radius.circular(Controller.roundCorner))),
                                                        margin:const EdgeInsets.only(left: Controller.leftCardColorMargin),
                                                        padding:const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                                        child:Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          children: [
                                                            CustomTextWidget(
                                                              text: leaveData[index]
                                                                  .count
                                                                  .toString(),
                                                              color: Colors.black,
                                                              size: 18,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                            const SizedBox(height: 5),
                                                            CustomTextWidget(
                                                              text: leaveData[index]
                                                                  .name
                                                                  .toString(),
                                                              color: Colors.black,
                                                            ),
                                                          ],
                                                        ),
                                                    )


                                                    ,
                                                  );





                                              }),


                                    ],
                                  ),
                            ),
                              ),
                        ),

              ],
            ),
          ),
        ],
      ),
    );
  }


  void changeButtonState(int status) {
    setState(() {
      buttonState = status;
    });

     request = ClaimShiftHistoryRequest();
    DateTime now = DateTime.now();
    if (status == 0)
    {
      var startDate =  DateTime(now.year, now.month, 1);
      var endDate = DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }
    else if (status == 1) {
      var startDate =  DateTime(now.year, now.month - 2, 1);
      var endDate =  DateTime(now.year, now.month - 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }
    else if (status == 2) {
      var startDate =  DateTime(now.year, 1, 1);
      var endDate =  DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }


    if (status < 3) {
      setState(() {
        _isFirstLoadRunning = true;
        _isErrorInApi = false;
        _reportsViewModel.getLeaveResports(request);
      });
    }
  }
}

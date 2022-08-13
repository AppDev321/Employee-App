import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/response/report_lateness_response.dart';
import 'package:hnh_flutter/widget/pie_chart.dart';

import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../repository/model/response/report_leave_response.dart';
import '../../utils/controller.dart';
import '../../view_models/reports_vm.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/dongout_chart.dart';
import '../../widget/error_message.dart';

class  LatenessReport extends StatefulWidget {
  const LatenessReport({Key? key}) : super(key: key);

  @override
  State<LatenessReport> createState() => LatenessReportStateful();
}

class LatenessReportStateful extends State<LatenessReport> {
  int buttonState = 0;
  TextEditingController _dateFilterController = TextEditingController();

// List<String> months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Nov","Dec"];
  //List<String> years = ["2018","2019","2020","2021","2022","2023","2024","2024"];

  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";

  late ReportsViewModel _reportsViewModel;
  LatenessData? latenessData = null;

  List<ChartData> chartData= [];

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
    var startDate = new DateTime(now.year, now.month, 1);
    var endDate =
        new DateTime(now.year, now.month + 1, 0); //this month last date

    var request = ClaimShiftHistoryRequest();
    request.start_date = Controller().getConvertedDate(startDate);
    request.end_date = Controller().getConvertedDate(endDate);

    _reportsViewModel.getLatenessResports(request);

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
          latenessData = _reportsViewModel.latenessData;

          if(latenessData != null)
            {
              chartData.clear();
              chartData.add(
                  ChartData(name:"Shift",count:latenessData!.totalShifts) );
              chartData.add(
                  ChartData(name:"Late",count:latenessData!.totalLates));

            }
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomTextWidget(
                text: subMenuReportLateness,
                size: 20,
              ),
            ),
            AnimatedButtonBar(
              padding: EdgeInsets.all(9),
              backgroundColor: Colors.grey.shade200,
              radius: 20,
              invertedSelection: true,
              children: [

                ButtonBarEntry(
                    onTap: () {
                      changeButtonState(0);
                    },
                    child: Text('This Month')),
                ButtonBarEntry(
                    onTap: () {

                      changeButtonState(1);
                    },
                    child: Text('Last Month')),
                ButtonBarEntry(
                    onTap: () {

                      changeButtonState(2);
                    },
                    child: Text('This Year')),
                ButtonBarEntry(
                    onTap: () {
                      changeButtonState(3);
                    },
                    child: Text('Custom'))
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: buttonState == 3
                    ? CustomDateRangeWidget(
                        labelText: "Select Date",
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

                          var request = ClaimShiftHistoryRequest();
                          request.start_date = startDate;
                          request.end_date = endDate;
                          _reportsViewModel.getLatenessResports(request);
                        },
                        controllerDate: _dateFilterController,
                        isSearchButtonShow: false,
                      )
                    : buttonState == 1
                        ? Center()
                        : buttonState == 2
                            ? Center()
                            : Center()),
            _isFirstLoadRunning
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _isErrorInApi
                    ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                    : Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                                children: [
                                  DoughnutChart(chartData: chartData),
                                 SizedBox(height:10),
                                  latenessData != null?
                                      GridView.count(
                                        shrinkWrap: true,
                                      primary: false,
                                        padding: EdgeInsets.all(5),
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      children: <Widget>[
                                        containerItem("Total Shifts",latenessData!.totalShifts.toString(),0),
                                        containerItem("Total Late",latenessData!.totalLates.toString(),1),
                                       // containerItem("Late Percentage",latenessData!.latePercentage.toString(),2)
                                      ],
                                      ): Center(),







                                ],
                              ),
                        ),
                          ),
                    ),

          ],
        ),
      ),
    );
  }


  Widget containerItem(String label, String count,int index)
  {
    return

      Card(
        color:  colorArray[index],
        elevation: 5,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child:
      Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10))),
      margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child:
      Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          CustomTextWidget(
            text: count
                .toString(),
            color: Colors.black,
            size: 18,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          CustomTextWidget(
            text: label
                .toString(),
            color: Colors.black,
          ),
        ],
      ),
    ));
  }



  void changeButtonState(int status) {
    setState(() {
      buttonState = status;
    });

    var request = ClaimShiftHistoryRequest();
    DateTime now = DateTime.now();
    if (status == 0)
    {
      var startDate = new DateTime(now.year, now.month, 1);
      var endDate =new DateTime(now.year, now.month + 1, 0); //this month last date
     request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
     }
    else if (status == 1) {
      var startDate = new DateTime(now.year, now.month - 2, 1);
      var endDate = new DateTime(now.year, now.month - 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
     }
    else if (status == 2) {
      var startDate = new DateTime(now.year, 1, 1);
      var endDate = new DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }


    if (status < 3) {
      setState(() {
        _isFirstLoadRunning = true;
        _isErrorInApi = false;
        _reportsViewModel.getLatenessResports(request);
      });
    }
  }
}

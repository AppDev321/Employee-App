import 'package:flutter/material.dart';
import 'package:hnh_flutter/pages/shift/claimed_shift_list.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_request.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/report_attendance_response.dart';
import 'package:hnh_flutter/repository/model/response/vehicle_list_response.dart';
import 'package:hnh_flutter/view_models/base_view_model.dart';
import 'package:hnh_flutter/webservices/APIWebServices.dart';
import 'package:intl/intl.dart';

import '../repository/model/request/claim_shift_history_request.dart';
import '../repository/model/response/claimed_shift_list.dart';
import '../repository/model/response/report_lateness_response.dart';
import '../repository/model/response/report_leave_response.dart';
import '../widget/custom_text_widget.dart';

class ReportsViewModel extends BaseViewModel {



  List<ChartData> leaveData = [];
  List<Attendance> attandenceList = [];
  List<Summary> summaryList=[];
  LatenessData? latenessData = null;



  Future<void> getLeaveResports(ClaimShiftHistoryRequest request) async {
    setLoading(true);
    final results = await APIWebService().getLeaveReport(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data!.totalLeaves! > 0)
          {
            leaveData = results.data!.leaveData!;
          }
        else
          {
            setIsErrorReceived(true);
            leaveData=[];
            setErrorMsg("No Report found");
          }

      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


  Future<void> getAttendanceReport(ClaimShiftHistoryRequest request) async {
    setLoading(true);
    final results = await APIWebService().getAttendanceReport(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data!.attendance!.length > 0)
        {
          attandenceList =results.data!.attendance!;
        }
        else
        {
          setIsErrorReceived(true);
          attandenceList=[];
          setErrorMsg("No Report found");
        }


      }
      else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }

  showBottomSheet(
      BuildContext context, List<Summary> summaryItemList) async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
      ),
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.white,
      context: context,

      builder: (context) => DraggableScrollableSheet(expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.1,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return SingleChildScrollView(
              controller: scrollController,
              child: SafeArea(
                child: Container(
                  color: Colors.white12,
                  child: Wrap(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns:  <DataColumn>[
                          DataColumn(
                              label: CustomTextWidget(
                                text: "Sr#",
                                fontWeight: FontWeight.bold,
                              )),
                          DataColumn(label: CustomTextWidget(text: "Time In", fontWeight: FontWeight.bold,)),
                          DataColumn(label: CustomTextWidget(text: "Time Out",fontWeight: FontWeight.bold,)),
                          DataColumn(label: CustomTextWidget(text: "Total Time", fontWeight: FontWeight.bold,)),
                        ], rows: _createRows(summaryItemList)
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        },
      ),
    );

  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    String timeString = "";
    List<String> parts = d.toString().split(':');
    ;
    if (parts.length > 1) {
      if (parts[1] != '00') {
        timeString =
        '${parts[0].padLeft(2, '0')} hour ${parts[1].padLeft(2, '0')} min';
      }
      else
      {
        timeString = '${parts[0].padLeft(2, '0')} hour';
      }
    } else {
      timeString = '${parts[0].padLeft(2, '0')} hour';
    }
    return timeString;
  }



  List<DataRow> _createRows(List<Summary> summaryItemList) {
    return summaryItemList
        .map((item) => DataRow(cells: [
      DataCell(Text('${summaryItemList.indexOf(item) + 1}')),
      DataCell(CustomTextWidget(text: item.timeIn.toString())),
      DataCell(CustomTextWidget(text: item.timeOut.toString())),
      DataCell(
          CustomTextWidget(text: durationToString(item.totalTime!))),
    ]))
        .toList();
  }
  Future<void> getLatenessResports(ClaimShiftHistoryRequest request) async {
    setLoading(true);
    final results = await APIWebService().getLatenessReport(request);

    if (results == null) {
      var errorString = "Check your internet connection";
      setErrorMsg(errorString);
      setIsErrorReceived(true);
    } else {
      if (results.code == 200) {
        setIsErrorReceived(false);
        if(results.data != null)
        {
          latenessData = results.data;



        }
        else
        {
          setIsErrorReceived(true);
          setErrorMsg("No Report found");

        }

      } else {
        var errorString = "";
        for (int i = 0; i < results.errors!.length; i++) {
          errorString += results.errors![i].message! + "\n";
        }
        setErrorMsg(errorString);
        setIsErrorReceived(true);
      }
    }

    setResponseStatus(true);
    setLoading(false);
    notifyListeners();
  }


  String convertStringDate(String jsonDate , String parsingType)
  {

    DateTime parseDate =  DateFormat("dd-MMM-yyyy").parse(jsonDate);
   var dateFormat =  DateFormat('E MMM dd yyyy');

   switch(parsingType)
   {
     case "month":
       dateFormat =  DateFormat('MMM');
       break;
     case "date":
       dateFormat =  DateFormat('dd');
       break;
     case "year":
       dateFormat =  DateFormat('yyyy');
       break;
     case "day":
       dateFormat =  DateFormat('E');
       break;

   }


    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = dateFormat;
    var outputDate = outputFormat.format(inputDate);
    return outputDate;

  }

}

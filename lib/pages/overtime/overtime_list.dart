import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/pages/leave/add_my_leave.dart';
import 'package:hnh_flutter/view_models/leave_list_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:hnh_flutter/widget/table_cell_padding.dart';
import 'package:get/get.dart';
import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../repository/model/response/leave_list.dart';
import '../../repository/model/response/overtime_list.dart';
import '../../utils/controller.dart';
import '../../view_models/overtime_vm.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/filter_tab_widget.dart';
import '../../widget/internet_not_available.dart';
import '../login/login.dart';
import 'add_overtime.dart';

class OverTimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OverTimePageState();
  }
}

class _OverTimePageState extends State<OverTimePage> with SingleTickerProviderStateMixin{
  TextEditingController _dateFilterController = TextEditingController();
  bool _isFirstLoadRunning = false;
  late TabController _tabController;
  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<OvertimeHistory> _overtimeHistoryList = [];

  late BuildContext contextBuild;
  late OvertimeViewModel _overtimeViewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ConstantData.filterTabs.length, vsync: this);


    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _overtimeViewModel = OvertimeViewModel();
    var now = new DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);

    var request = ClaimShiftHistoryRequest();
    request.start_date = formattedDate;
    request.end_date = formattedDate;

    _overtimeViewModel.getOverTimeList(request);
    _overtimeViewModel.addListener(() {
      _overtimeHistoryList.clear();

      var checkErrorApiStatus = _overtimeViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _overtimeViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        _isFirstLoadRunning = false;

        _overtimeHistoryList = _overtimeViewModel.getOvertimeHistoryList();

        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(overtime),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            BlocBuilder<ConnectedBloc, ConnectedState>(
                builder: (context, state) {
                  if (state is ConnectedFailureState) {
                    return InternetNotAvailable();
                  }else
                  {
                    return Container();
                  }
                }
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: CustomTextWidget(
                    text: "Add Request",
                    size: 20,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                Get.to(()=> AddOverTime());


                  },
                  child: Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    primary: primaryColor,
                    onPrimary: Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomDateRangeWidget(
              labelText: "Select Date",
              onDateChanged: (date) {
                String startDate = Controller().getConvertedDate(date['start']);
                String endDate = Controller().getConvertedDate(date['end']);
                _dateFilterController.text = "$startDate To $endDate";
              },
              onFetchDates: (date) {
                String startDate = Controller().getConvertedDate(date['start']);
                String endDate = Controller().getConvertedDate(date['end']);
                setState(() {

                  var request = ClaimShiftHistoryRequest();
                  request.start_date = startDate;
                  request.end_date = endDate;
                  _overtimeHistoryList.clear();
                  _isFirstLoadRunning = true;
                  _isErrorInApi = false;
                  _overtimeViewModel.getOverTimeList(request);


                });
              },
              controllerDate: _dateFilterController,
              isSearchButtonShow: false,
            ),


            SizedBox(
              height: 15,
            ),
            CustomFilterTab(controller: _tabController, tabs: ConstantData.filterTabs,),



            SizedBox(
              height: 15,
            ),
            _isFirstLoadRunning
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _isErrorInApi
                    ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                    : Expanded(
                        child: _overtimeHistoryList.length > 0
                            ?

                        TabBarView(
                            controller: _tabController,
                            children: [
                              //All

                              listContainer(_overtimeHistoryList),

                              listContainer(getFilterList(_overtimeHistoryList,"APPROVED")),

                              listContainer(getFilterList(_overtimeHistoryList,"PENDING")),
                              listContainer(getFilterList(_overtimeHistoryList,"REJECTED")),

                            ])  : ErrorMessageWidget(label: "No Overtime Found"))
          ],
        ),
      ));



  List<OvertimeHistory> getFilterList(List<OvertimeHistory> inputlist,String status) {
    List<OvertimeHistory> outputList = inputlist.where((o) => o.status == status).toList();
    return outputList;
  }

  Widget listContainer(List<OvertimeHistory> _leaveHistoryList)
  {

    return  ListView.builder(
        itemCount: _leaveHistoryList.length,
        itemBuilder: (_, index) => Padding(
            padding: const EdgeInsets.all(5.0),
            child: containerListItems(
                _leaveHistoryList[index])));
  }




  Widget containerListItems(OvertimeHistory item) {
    return Card(
        color:   item.status == "PENDING"  ? claimedShiftColor :
        item.status == "APPROVED" ? claimedShiftApprovedColor :
        claimedShiftRejectColor,
        elevation: 5,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        clipBehavior: Clip.antiAlias,
        child:

        Container(
            decoration: BoxDecoration(
              color:  Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10))

            ),
            margin: EdgeInsets.only(left:Controller.leftCardColorMargin),

            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      TextColorContainer(
                      label: item.status!,
                      color:
                      item.status == "PENDING"  ? claimedShiftColor:
                      item.status == "APPROVED" ? claimedShiftApprovedColor :
                      claimedShiftRejectColor),

                    ],
                  ),
                ),

                SizedBox(
                  height: 6,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      
                      createRowDate("Date:",item.date),
                      SizedBox(
                        height: 5,
                      ),
                      createRowDate("Hours:",item.hour),
                      SizedBox(
                        height: 5,
                      ),
                      createRowDate("Reason:",item.reason),
                      SizedBox(
                        height: 5,
                      ),
                       item.status == "APPROVED" || item.status == "REJECTED" ?
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child:
                        createRowDate("Managed By:",item.managedBy),

                      ):
                      Container(),
                    ],
                  ),
                )
              ],
            )));
  }


  Widget createRowDate(String title,String? value)
  {

    return Column(
      children: [
        SizedBox(
          height: 5,
        ),

        Row(
          children: [
            CustomTextWidget(  text:title,fontWeight: FontWeight.bold),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child:
                  CustomTextWidget(  text:value)),
            )

          ],
        )
      ],
    )
    ;
  }



}

import 'dart:math';

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
import '../../utils/controller.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/filter_tab_widget.dart';
import '../../widget/internet_not_available.dart';


class LeavePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LeavePageState();
  }
}

class _LeavePageState extends State<LeavePage>   with SingleTickerProviderStateMixin {
  TextEditingController _dateFilterController = TextEditingController();
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<Leaves> _leaveHistoryList = [];

  late BuildContext contextBuild;
  late LeaveListViewModel _leaveListViewModel;

  late TabController _tabController;

  var request =ClaimShiftHistoryRequest() ;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ConstantData.filterTabs.length, vsync: this);



    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _leaveListViewModel = LeaveListViewModel();
    var now = new DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);

  //  var request = ClaimShiftHistoryRequest();
    request = ClaimShiftHistoryRequest();
    request.start_date = formattedDate;
    request.end_date = formattedDate;

    _leaveListViewModel.getLeaveHistoryList(request);
    _leaveListViewModel.addListener(() {
      _leaveHistoryList.clear();

      var checkErrorApiStatus = _leaveListViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _leaveListViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        _isFirstLoadRunning = false;

        _leaveHistoryList = _leaveListViewModel.getLeaveList();

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
        title: Text(menuLeave),
      ),
      body: Column(
        children: [

          BlocBuilder<ConnectedBloc, ConnectedState>(
              builder: (context, state) {
                if (state is ConnectedFailureState) {
                  return InternetNotAvailable();
                }
                else if(state is FirebaseMsgReceived)
                {
                  if(state.screenName == Screen.OVERTIME)
                  {
                    _leaveListViewModel.getLeaveHistoryList(request);
                    print("updating overtime Screen");
                    state.screenName=Screen.NULL;

                  }
                  return Container();
                }

                else
                {
                  return Container();
                }
              }
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [



                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [



                      Container(
                        child: CustomTextWidget(
                          text: "Add Leave",
                          size: 20,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                    var leavesType = _leaveListViewModel.getLeaveTypes();
                    if(leavesType.length > 0) {

                      Get.to(()=> AddLeave(leaveTypes: leavesType));
                    }
                    else
                      {
                        Controller().showToastMessage(context,"No leave types found");
                      }


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

                      //  var request = ClaimShiftHistoryRequest();
                        request = ClaimShiftHistoryRequest();
                        request.start_date = startDate;
                        request.end_date = endDate;
                        _leaveHistoryList.clear();
                        _isFirstLoadRunning = true;
                        _isErrorInApi = false;
                        _leaveListViewModel.getLeaveHistoryList(request);


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
                              child: _leaveHistoryList.length > 0
                                  ?
                              TabBarView(
                                controller: _tabController,
                                children: [
                                  //All

                                  listContainer(_leaveHistoryList),

                                  listContainer(getFilterList(_leaveHistoryList,ConstantData.approved)),

                                  listContainer(getFilterList(_leaveHistoryList,ConstantData.pending)),
                                  listContainer(getFilterList(_leaveHistoryList,ConstantData.rejected)),

                                ],
                              )
                      : ErrorMessageWidget(label: "No Leaves Found"))
                ],
              ),
            ),
          ),
        ],
      ));



  List<Leaves> getFilterList(List<Leaves> inputlist,String status) {
    List<Leaves> outputList = inputlist.where((o) => o.status == status).toList();
    return outputList;
  }

  Widget listContainer(List<Leaves> _leaveHistoryList)
  {

   return  RefreshIndicator(
     onRefresh:  ()=>_leaveListViewModel.getLeaveHistoryList(request),
     child: ListView.builder(
          itemCount: _leaveHistoryList.length,
          itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: containerListItems(
                  _leaveHistoryList[index]))),
   );
  }




  Widget containerListItems(Leaves item) {
    return Card(
        color:   item.status == ConstantData.pending  ? claimedShiftColor :
        item.status == ConstantData.approved ? claimedShiftApprovedColor :
        claimedShiftRejectColor,
        elevation: 5,
        shadowColor: cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Controller.roundCorner),
        ),
        clipBehavior: Clip.antiAlias,
        child:

        Container(
            decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(Controller.roundCorner),
                    topRight: Radius.circular(Controller.roundCorner))

            ),
            margin: EdgeInsets.only(left:Controller.leftCardColorMargin),

            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: item.leaveType,
                        color:  Colors.primaries[Random().nextInt(Colors.primaries.length)],
                        fontWeight: FontWeight.w500,
                      ),
                      TextColorContainer(
                      label: item.status!,
                      color:
                      item.status == ConstantData.pending  ? claimedShiftColor:
                      item.status == ConstantData.approved ? claimedShiftApprovedColor :
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
                      containerCard(item),
                      SizedBox(
                        height: 15,
                      ),

                      item.status == ConstantData.approved || item.status == ConstantData.rejected ?
                      Padding(
                        padding: const EdgeInsets.all(7),
                        child:

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: "Managed By:",
                              fontWeight: FontWeight.bold,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: CustomTextWidget(text: item.managedBy),
                            ),
                          ],
                        ),
                      ):
                      Container(),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget containerCard(Leaves item) {
    return Table(

        children: [
      TableRow(
        children: [
          TableCellPadded(
              child: CustomTextWidget(
            text: "From Date",
            fontWeight: FontWeight.bold,
          )),
          TableCellPadded(
              child: CustomTextWidget(
            text: "To Date",
            fontWeight: FontWeight.bold,
          )),
          TableCellPadded(
              child: CustomTextWidget(
            text: "Days",
            fontWeight: FontWeight.bold,
          )),
        ],
      ),
      TableRow(
        children: [
          TableCellPadded(
              child: CustomTextWidget(
            text: item.dateFrom,
          )),
          TableCellPadded(
              child: CustomTextWidget(
            text: item.dateTo,
          )),
          TableCellPadded(
              child: CustomTextWidget(
            text: "${item.days} days",
          )),
        ],
      ),
    ]);
  }




}

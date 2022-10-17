import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../repository/model/response/overtime_list.dart';
import '../../repository/model/response/report_leave_response.dart';
import '../../utils/controller.dart';
import '../../view_models/overtime_vm.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/dongout_chart.dart';
import '../../widget/error_message.dart';
import '../../widget/filter_tab_widget.dart';
import '../../widget/internet_not_available.dart';
import 'add_overtime.dart';

class OverTimePage extends StatefulWidget {
  const OverTimePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OverTimePageState();
  }
}

class _OverTimePageState extends State<OverTimePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _dateFilterController = TextEditingController();
  bool _isFirstLoadRunning = false;
  late TabController _tabController;
  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<OvertimeHistory> _overtimeHistoryList = [];

  late BuildContext contextBuild;
  late OvertimeViewModel _overtimeViewModel;
  var request = ClaimShiftHistoryRequest();
  List<ChartData> chartData = [];
  bool hideWidget=false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: ConstantData.filterTabs.length, vsync: this);

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _overtimeViewModel = OvertimeViewModel();
    var now = DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);

    request = ClaimShiftHistoryRequest();
    request.start_date = formattedDate;
    request.end_date = formattedDate;

    // _overtimeViewModel.getOverTimeList(request);
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
        chartData.clear();
        chartData.add(ChartData(
            name: ConstantData.approved,
            count:
                getCountDataList(_overtimeHistoryList, ConstantData.approved)));
        chartData.add(ChartData(
            name: ConstantData.pending,
            count:
                getCountDataList(_overtimeHistoryList, ConstantData.pending)));
        chartData.add(ChartData(
            name: ConstantData.rejected,
            count:
                getCountDataList(_overtimeHistoryList, ConstantData.rejected)));

        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: const Key('overtime-widget'),
        onVisibilityChanged: (VisibilityInfo info) {
          var isVisibleScreen = info.visibleFraction == 1.0 ? true : false;

          if (isVisibleScreen) {
            setState(() {
              _overtimeHistoryList.clear();
              _isFirstLoadRunning = true;
              _isErrorInApi = false;
              _overtimeViewModel.getOverTimeList(request);
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(overtime),

            ),
            body: Column(mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ConnectedBloc, ConnectedState>(
                    builder: (context, state) {
                  if (state is ConnectedFailureState) {
                    return InternetNotAvailable();
                  } else if (state is FirebaseMsgReceived) {
                    if (state.screenName == Screen.OVERTIME) {
                      _overtimeViewModel.getOverTimeList(request);
                      state.screenName = Screen.NULL;
                    }
                    return Container();
                  } else {
                    return Container();
                  }
                }),
                Expanded(

                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const CustomTextWidget(
                              text: "Add Request",
                              size: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => const AddOverTime());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                primary: primaryColor,
                                onPrimary: Colors.black,
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDateRangeWidget(
                          labelText: "Select Date",
                          onDateChanged: (date) {
                            String startDate =
                                Controller().getConvertedDate(date['start']);
                            String endDate =
                                Controller().getConvertedDate(date['end']);
                            _dateFilterController.text =
                                "$startDate To $endDate";
                          },
                          onFetchDates: (date) {
                            String startDate =
                                Controller().getConvertedDate(date['start']);
                            String endDate =
                                Controller().getConvertedDate(date['end']);
                            setState(() {
                              request = ClaimShiftHistoryRequest();
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
                      _overtimeHistoryList.isNotEmpty
                          ?

                      Column(
                        children: [
                          hideWidget==true?
                          Container(
                              height: Get.mediaQuery.size.width / 3,
                              child:
                              DoughnutChart(chartData: chartData)):Center(),
                          const SizedBox(height: 5)
                        ],
                      )
                          : const SizedBox(height: 10),
                        CustomFilterTab(
                          controller: _tabController,
                          tabs: ConstantData.filterTabs,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _isFirstLoadRunning
                            ? const Expanded(flex: 5,
                            child:
                            Center(child: CircularProgressIndicator()))
                            : _isErrorInApi
                            ? Expanded(
                            child:
                            ErrorMessageWidget(label: _errorMsg!))
                            : Expanded(flex: 5,
                            child: _overtimeHistoryList.isNotEmpty
                                ? TabBarView(
                                controller: _tabController,
                                children: [
                                  //All

                                  listContainer(
                                        _overtimeHistoryList),
                                  

                                  listContainer(getFilterList(
                                      _overtimeHistoryList,
                                      ConstantData.approved)),

                                  listContainer(getFilterList(
                                      _overtimeHistoryList,
                                      ConstantData.pending)),
                                  listContainer(getFilterList(
                                      _overtimeHistoryList,
                                      ConstantData.rejected)),
                                ])
                                : const ErrorMessageWidget(
                                label: "No Overtime Found"))],)

                  ),
                ),
              ],
            )),
      );

  int getCountDataList(List<OvertimeHistory> inputlist, String status) {
    List<OvertimeHistory> outputList =
        inputlist.where((o) => o.status == status).toList();
    return outputList.length;
  }

  List<OvertimeHistory> getFilterList(
      List<OvertimeHistory> inputlist, String status) {
    List<OvertimeHistory> outputList =
        inputlist.where((o) => o.status == status).toList();
    return outputList;
  }

  Widget listContainer(List<OvertimeHistory> _leaveHistoryList) {
    return RefreshIndicator(
      onRefresh: () => _overtimeViewModel.getOverTimeList(request),
      child: ListView.builder(
          itemCount: _leaveHistoryList.length,
          itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: containerListItems(_leaveHistoryList[index]))),
    );
  }

  Widget containerListItems(OvertimeHistory item) {
    return Card(
        color: item.status == ConstantData.pending
            ? claimedShiftColor
            : item.status == ConstantData.approved
            ? claimedShiftApprovedColor
            : claimedShiftRejectColor,
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
            margin: const EdgeInsets.only(left: Controller.leftCardColorMargin),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: cardThemeBaseColor,
                    borderRadius: BorderRadius.circular(0),
                  ),

                  child: Column(
                    children: [
                      createRowDate("Date:", item.date,false),

                      createRowDate("Hours:", item.hour,false),

                      createRowDate("Reason:", item.reason,true),

                      item.status == ConstantData.approved ||
                          item.status == ConstantData.rejected
                          ? Padding(
                        padding: const EdgeInsets.all(0),
                        child:
                        createRowDate("Managed By:", item.managedBy,false),
                      )
                          : Container(),
                    ],
                  ),
                ), const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextColorContainer(
                        label: item.status!,
                        color: item.status == ConstantData.pending
                            ? claimedShiftColor
                            : item.status == ConstantData.approved
                            ? claimedShiftApprovedColor
                            : claimedShiftRejectColor),
                    const SizedBox(
                      width: 10,
                    ),
                    item.status == ConstantData.pending
                        ? InkWell(
                      onTap: () {
                        Controller().showConfirmationMsgDialog(
                            context,
                            "Confirm",
                            "Are you sure you want to delete?",
                            "Yes", (value) {
                          if (value) {
                            setState(() {
                              _overtimeHistoryList.remove(item);
                              _overtimeViewModel.deleteOverTimeRequest( item.id.toString());
                            });
                          }
                        });
                      },
                      child: TextColorContainer(
                        label: "Delete",
                        color: claimedShiftRejectColor,
                        icon: Icons.delete,
                      ),
                    )
                        : const Center(),
                  ],
                ),
              ],
            )));
  }

  Widget createRowDate(String title, String? value,bool isMaxLine) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(text: title, fontWeight: FontWeight.bold),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CustomTextWidget(text: value, maxLines:isMaxLine? 2:1,)),
            )
          ],
        )
      ],
    );
  }
}

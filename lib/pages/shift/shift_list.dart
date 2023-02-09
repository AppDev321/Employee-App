import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnh_flutter/data/drawer_items.dart';
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/view_models/shift_list_vm.dart';
import 'package:hnh_flutter/widget/internet_not_available.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../custom_style/strings.dart';
import '../../repository/model/request/claim_shift_request.dart';
import '../../utils/controller.dart';
import '../../widget/calander_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/error_message.dart';

class ShiftList extends StatefulWidget {
  const ShiftList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShiftListState();
  }
}

class ShiftListState extends State<ShiftList> with TickerProviderStateMixin {
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<Shifts> _shiftList = [];
  List<Shifts> _openShiftList = [];

  late BuildContext contextBuild;
  late ShiftListViewModel _shiftListViewModel;

  final CalendarController _controller = CalendarController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _shiftListViewModel = ShiftListViewModel();

    var now = DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);
    _shiftListViewModel.getShiftList(formattedDate);

    _shiftListViewModel.addListener(() {
      _shiftList.clear();
      _openShiftList.clear();

      var checkErrorApiStatus = _shiftListViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _shiftListViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        _shiftList = _shiftListViewModel.getMyShiftList();
        _openShiftList = _shiftListViewModel.getOpenShiftList();
        _isFirstLoadRunning = false;

        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
      }

      //Check claim Status
      var isClaimSuccessFul = _shiftListViewModel.claimResponseSuccess;
      if (isClaimSuccessFul) {
        Controller().showToastMessage(context, "Claim Successful");

        _shiftListViewModel.getShiftList(Controller().getConvertedDate(now));
        _shiftListViewModel.setClaimResponse(false);
      }

      var showClaimError = _shiftListViewModel.getClaimError();
      if (showClaimError) {
        var snackBar =
            SnackBar(content: Text(_shiftListViewModel.getErrorMsg()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _shiftListViewModel.setClaimError(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: 2, vsync: this);
    contextBuild = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text(menuShift),
      ),
      body: Column(
        children: [
          BlocBuilder<ConnectedBloc, ConnectedState>(builder: (context, state) {
            if (state is ConnectedFailureState) {
              return const InternetNotAvailable();
            } else if (state is FirebaseMsgReceived) {
              if (state.screenName == Screen.SHIFT) {
                var now = DateTime.now();
                String formattedDate = Controller().getConvertedDate(now);
                _shiftListViewModel.getShiftList(formattedDate);
                state.screenName = Screen.NULL;
              }
              return Container();
            } else {
              return Container();
            }
          }),

          Expanded(
            child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, InnerBox) => [
                      SliverToBoxAdapter(
                        child: CustomCalanderWidget(
                          controller: _controller,
                          onChanged: (String value) {
                            setState(() {
                              _shiftList.clear();
                              _openShiftList.clear();
                              _isFirstLoadRunning = true;
                              _isErrorInApi = false;
                              _shiftListViewModel.getShiftList(value);
                            });
                          },
                        ),
                      )
                    ],
                body: Column(
                  children: [
                    _isFirstLoadRunning
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()))
                        : _isErrorInApi
                            ? Expanded(
                                child: ErrorMessageWidget(label: _errorMsg!))
                            : Expanded(
                                flex: 1,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        color: primaryColor,
                                        child: TabBar(
                                          controller: _tabController,
                                          indicatorColor: Colors.white,
                                          labelColor: cardThemeBaseColor,
                                          unselectedLabelColor: Colors.white54,
                                          tabs: const [
                                            Tab(text: 'My Shift'),
                                            Tab(text: 'Open Shift')
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              _shiftList.isNotEmpty
                                                  ? showListData(context,
                                                      _shiftList, false)
                                                  : const ErrorMessageWidget(
                                                      label: "No Shift Found"),
                                              _openShiftList.isNotEmpty
                                                  ? showListData(context,
                                                      _openShiftList, true)
                                                  : const ErrorMessageWidget(
                                                      label:
                                                          "No Open  Shift Found")
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ],
                )),
          )
          // CustomCalanderWidget(
          //   controller: _controller,
          //   onChanged: (String value) {
          //     setState(() {
          //       _shiftList.clear();
          //       _openShiftList.clear();
          //       _isFirstLoadRunning = true;
          //       _isErrorInApi = false;
          //       _shiftListViewModel.getShiftList(value);
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Widget showListData(
      BuildContext context, List<Shifts> shifts, bool openShiftData) {
    return RefreshIndicator(
      onRefresh: () {
        var now = DateTime.now();
        String formattedDate = Controller().getConvertedDate(now);
        return _shiftListViewModel.getShiftList(formattedDate);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: shifts.length,
          itemBuilder: (_, index) => Card(
            color: openShiftData
                ? claimedShiftColor
                : shifts[index].claimed == null
                    ? claimedShiftApprovedColor
                    : shifts[index].claimed == true
                        ? claimedShiftColor
                        : claimedShiftApprovedColor,
            elevation: 5,
            shadowColor: cardShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Controller.roundCorner),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: cardThemeBaseColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(Controller.roundCorner),
                        topRight: Radius.circular(Controller.roundCorner))),
                margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: indexBuilder(context, index, shifts, openShiftData)),
          ),
        ),
      ),
    );
  }

  Widget indexBuilder(BuildContext context, int index, List<Shifts> shifts,
      bool openShiftData) {
    final data = shifts[index];
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(0),
          title: LayoutBuilder(
            builder: (context, constraint) {
              return itemShiftList(context, data, openShiftData);
            },
          ),
          children: <Widget>[
            openShiftData
                ? Container(child: itemOpenShiftDetail(context, data))
                : Container(child: itemShiftDetail(context, data)),
          ],
        ));
  }

  Widget itemShiftList(BuildContext context, Shifts item, bool openShift) {
    var isClaimed = item.claimed;
    isClaimed ??= false;

    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                openShift
                    ? Container()
                    : CustomTextWidget(
                        text: item.empName ?? 'N/A',
                        fontWeight: FontWeight.bold),
                CustomTextWidget(text: item.designation ?? 'N/A'),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: primaryColor,
                      size: 20.0,
                    ),
                    CustomTextWidget(text: item.location ?? 'N/A'),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                createRowDate(
                    "Shift Date:", "${item.date == '' ? 'N/A' : item.date}"),
                createRowDate("Shift Time:",
                    "${item.shiftTime == '' ? 'N/A' : item.shiftTime}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemShiftDetail(BuildContext context, Shifts item) {
    var isClaimed = item.claimed;
    isClaimed ??= false;
    return Center(
      child: Container(child: detailInfoItems(item)),
    );
  }

  Widget itemOpenShiftDetail(BuildContext context, Shifts item) {
    var isClaimed = item.claimed;
    isClaimed ??= false;

    return Column(children: [
      detailInfoItems(item),
      isClaimed
          ? createRowDate("Claim Status:", "Already Claimed")
          : Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: claimedShiftColor, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  setState(() {
                    _isFirstLoadRunning = true;
                    _isErrorInApi = false;
                    var request = ClaimShiftRequest();
                    request.openShiftId = item.id.toString();
                    _shiftListViewModel.claimOpenShift(request);
                  });
                },
                child: const Text('Claim this Shift'),
              ),
            )
    ]);
  }

  Widget subInformation(Shifts item) {
    return Column(children: [
      createRowDate("Name:", "${item.empName == '' ? 'N/A' : item.empName}"),
      createRowDate("Designation:",
          "${item.designation == '' ? 'N/A' : item.designation}"),
      createRowDate(
          "Location:", "${item.location == '' ? 'N/A' : item.location}"),
      createRowDate("Shift Date:", "${item.date == '' ? 'N/A' : item.date}"),
      createRowDate(
          "Shift Time:", "${item.shiftTime == '' ? 'N/A' : item.shiftTime}")
    ]);
  }

  Widget detailInfoItems(Shifts item) {
    return Column(children: [
      createRowDate(
          "Break Time:", "${item.shiftBreak == '' ? 'N/A' : item.shiftBreak}"),
      createRowDate("Vehicle:", "${item.vehicle == '' ? 'N/A' : item.vehicle}"),
      createRowDate("Notes:", "${item.note == '' ? 'N/A' : item.note}")
    ]);
  }

  Widget createRowDate(String title, String? value) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            CustomTextWidget(text: title, fontWeight: FontWeight.bold),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: CustomTextWidget(text: value)),
            )
          ],
        )
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnh_flutter/repository/model/request/claim_shift_history_request.dart';
import 'package:hnh_flutter/repository/model/response/claimed_shift_list.dart';
import 'package:hnh_flutter/view_models/shift_list_vm.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../utils/controller.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';

class ClaimedShiftList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ClaimedShiftListState();
  }
}

class ClaimedShiftListState extends State<ClaimedShiftList>  {
  bool _isFirstLoadRunning = false;

  bool _isErrorInApi = false;
  String? _errorMsg = "";
  List<Claims> _claimedHistoryList = [];

  late BuildContext contextBuild;
  late ShiftListViewModel _shiftListViewModel;

  TextEditingController _dateFilterController = TextEditingController();


  @override
  void initState() {
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });



    _shiftListViewModel = ShiftListViewModel();
    var now = new DateTime.now();
    String formattedDate = Controller().getConvertedDate(now);

    var request = ClaimShiftHistoryRequest();
    request.start_date = formattedDate;
    request.end_date = formattedDate;

    _shiftListViewModel.getClaimedShiftHistoryList(request);
    _shiftListViewModel.addListener(() {
      _claimedHistoryList.clear();

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
        _claimedHistoryList = _shiftListViewModel.getClaimedHistoryShiftList();
        _isFirstLoadRunning = false;

        setState(() {
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    contextBuild = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(subMenuOpenShift),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
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

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomDateRangeWidget(labelText: "Select Date",
                onDateChanged: (date)
              {

                String startDate = Controller().getConvertedDate(date['start']);
                String endDate = Controller().getConvertedDate(date['end']);
                _dateFilterController.text = "$startDate To $endDate";

             //   var startDate = "${date['start'].year}-${date['start'].month}-${date['start'].day}";
             //   var endDate = "${date['end'].year}-${date['end'].month}-${date['end'].day}";
             //   _dateFilterController.text = "$startDate To $endDate";

              },
                onFetchDates: (date)
                {
                   String startDate = Controller().getConvertedDate(date['start']);
                  String endDate = Controller().getConvertedDate(date['end']);



                   setState(() {
                     var request = ClaimShiftHistoryRequest();
                     request.start_date = startDate;
                     request.end_date = endDate;
                     _claimedHistoryList.clear();
                     _isFirstLoadRunning = true;
                     _isErrorInApi = false;
                     _shiftListViewModel.getClaimedShiftHistoryList(request);
                   });


                },
                  controllerDate: _dateFilterController,
                isSearchButtonShow: false,
              ),
            ),
            _isFirstLoadRunning
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : _isErrorInApi
                ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                : Expanded(
                    child:
                    _claimedHistoryList.length >0?
                     showListData(context,_claimedHistoryList,false)
                        : ErrorMessageWidget(label: "No Shift Found")
                    )
          ],
        ),
      ),
    );
  }

  Widget showListData(
      BuildContext context, List<Claims> shifts, bool openShiftData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: shifts.length,
        itemBuilder: (_, index) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
              color: shifts[index].status == "PENDING"
                  ? claimedShiftColor
                  : shifts[index].status == "APPROVED"
                      ? claimedShiftApprovedColor
                      : claimedShiftRejectColor,
              elevation: 5,
              shadowColor: cardShadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  margin: EdgeInsets.only(left: Controller.leftCardColorMargin),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: indexBuilder(context, shifts[index]))),
        ),
      ),
    );
  }

  Widget indexBuilder(BuildContext context, Claims item) {
    return
      Theme(
          data:Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child:
          ExpansionTile(

            tilePadding:EdgeInsets.all(0),
            title: LayoutBuilder(
              builder: (context, constraint) {
                return    itemClaimedHistory(context, item);
              },
            ),

              children: <Widget>[
              Center(child: Container(child: itemShiftDetail(context, item)))
            ]));
  }

  Widget itemClaimedHistory(BuildContext context, Claims item) {

    return InkWell(
      onTap: () {},
      child:  IntrinsicHeight(
           child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                    color: primaryColor,
                    size: 20.0,
                  ),
                  CustomTextWidget(
                      text: item.shift!.location == ''
                          ? 'N/A'
                          : item.shift!.location),
                ],
              ),
              createRowDate("Designation:",
                  "${item.shift!.designation == '' ? 'N/A' : item.shift!.designation}"),
              createRowDate("Shift Date:", item.shift!.date),
              createRowDate("Shift Time:", item.shift!.shiftTime),
              createRowDate("Managed by:",
                  "${item.managedBy == '' ? 'N/A' : item.managedBy}"),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    CustomTextWidget(
                      text: "Status:",
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    TextColorContainer(
                        label: item.status!,
                        color: item.status == "PENDING"
                            ? claimedShiftColor
                            : item.status == "APPROVED"
                                ? claimedShiftApprovedColor
                                : claimedShiftRejectColor),
                  ],
                ),
              ),
            ],



      ),)
    );
  }
  Widget itemShiftDetail(BuildContext context, Claims item) {

    return
         Column(children:[
              createRowDate("Break Time:",item.shift!.shiftBreak),
              createRowDate("Vehicle:","${item.shift!.vehicle == '' ? 'N/A' : item.shift!.vehicle}"),
              createRowDate("Notes:","${item.shift!.note == '' ? 'N/A' : item.shift!.note}")
            ]
        );
  }
Widget createRowDate(String title,String? value,{Color color= Colors.black})
{

  return
Column(
      mainAxisSize: MainAxisSize.max,
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
                            CustomTextWidget(  text:value,color: color,)

                      ),
                    )
                  ],



        ),

      ],

  )
   ;
}


}

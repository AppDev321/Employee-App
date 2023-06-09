import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hnh_flutter/pages/availability/view_availability.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/colors.dart';
import '../../custom_style/strings.dart';
import '../../data/drawer_items.dart';
import '../../repository/model/request/availability_request.dart';
import '../../repository/model/request/claim_shift_history_request.dart';
import '../../utils/controller.dart';
import '../../view_models/availability_vm.dart';
import '../../widget/color_text_round_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/date_range_widget.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';
import 'add_my_availability.dart';

class AvailabilityList extends StatefulWidget {
  const AvailabilityList({Key? key}) : super(key: key);

  @override
  State<AvailabilityList> createState() => AvailabilityListStateful();
}

class AvailabilityListStateful extends State<AvailabilityList> {
  int buttonState = 0;
  final TextEditingController _dateFilterController = TextEditingController();
  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";

  late AvailabilityViewModel _availabilityViewModel;

  List<AvailabilityRequest> availabilities = [];

  DialogBuilder? _progressDialog;
  BuildContext? _dialogContext;

  bool isUpdateClick = false;

  late AvailabilityRequest deletedItemRequest;
  var request = ClaimShiftHistoryRequest();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _availabilityViewModel = AvailabilityViewModel();

    //Getting current month and date time
    DateTime now = DateTime.now();
    var startDate =  DateTime(now.year, now.month, 1);
    var endDate =
        DateTime(now.year, now.month + 1, 0); //this month last date

    request = ClaimShiftHistoryRequest();
    request.start_date = Controller().getConvertedDate(startDate);
    request.end_date = Controller().getConvertedDate(endDate);

    //  _availabilityViewModel.getAvailabilityList(request);

    _availabilityViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();

      var checkErrorApiStatus = _availabilityViewModel.getIsErrorRecevied();

      ///API ki Error
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _availabilityViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
          availabilities = _availabilityViewModel.availabilities!;
        });
      }

      if (isUpdateClick) {
        if (_availabilityViewModel.getRequestStatus()) {
          //Update ka error
          setState(() {
            _errorMsg = "";
            availabilities.remove(deletedItemRequest);
            if (availabilities.isEmpty) {
              _isErrorInApi = true;
              _errorMsg = ConstantData.noDataFound;
            }
          });

          Controller()
              .showToastMessage(context, "Request deleted successfully");
        } else {
          //
          _errorMsg = _availabilityViewModel.getErrorMsg();

          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
          }
        }

        setState(() {
          isUpdateClick = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    if (_progressDialog == null) {
      _progressDialog = DialogBuilder(_dialogContext!);
      _progressDialog?.initiateLDialog('Please wait..');
    }

    return VisibilityDetector(
      key: const Key('leave-widget'),
      onVisibilityChanged: (VisibilityInfo info) {
        var isVisibleScreen = info.visibleFraction == 1.0 ? true : false;

        if (isVisibleScreen) {
          setState(() {
            _isFirstLoadRunning = true;
            _isErrorInApi = false;
            _availabilityViewModel.getAvailabilityList(request);
          });
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(availability),
          ),
          body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    BlocBuilder<ConnectedBloc, ConnectedState>(
                        builder: (context, state) {
                      if (state is ConnectedFailureState) {
                        return InternetNotAvailable();
                      } else {
                        return Container();
                      }
                    }),
                   Expanded(
                     child: NestedScrollView(
                         floatHeaderSlivers: true,
                         headerSliverBuilder: (context,InnerBox)=>[
                           SliverToBoxAdapter(child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                               const CustomTextWidget(
                                        text: "Add Request",
                                        size: 20,
                                      ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => AddAvailability());
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
                           )],
                         body:  Column(children: [


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
                                   child: const CustomTextWidget(text:'This Month',size: 12,textAlign: TextAlign.center,),),
                               ButtonBarEntry(
                                   onTap: () {
                                     changeButtonState(1);
                                   },
                                 child: const CustomTextWidget(text:'Last Month',size: 12,textAlign: TextAlign.center,),),

                               ButtonBarEntry(
                                   onTap: () {
                                     changeButtonState(2);
                                   },
                                 child: const CustomTextWidget(text:'This Year',size: 12,textAlign: TextAlign.center,),),

                               ButtonBarEntry(
                                   onTap: () {
                                     changeButtonState(3);
                                   },
                                 child: const CustomTextWidget(text:'Custom',size: 12,textAlign: TextAlign.center,),),

                             ],
                           ),
                           Padding(
                               padding: const EdgeInsets.all(10),
                               child: buttonState == 3
                                   ? CustomDateRangeWidget(

                                 onDateChanged: (date) {
                                   String startDate = Controller()
                                       .getConvertedDate(date['start']);
                                   String endDate = Controller()
                                       .getConvertedDate(date['end']);
                                   _dateFilterController.text =
                                   "$startDate To $endDate";
                                 },
                                 onFetchDates: (date) {
                                   setState(() {
                                     _isFirstLoadRunning = true;
                                     _isErrorInApi = false;
                                   });

                                   String startDate = Controller()
                                       .getConvertedDate(date['start']);
                                   String endDate = Controller()
                                       .getConvertedDate(date['end']);

                                   request = ClaimShiftHistoryRequest();
                                   request.start_date = startDate;
                                   request.end_date = endDate;
                                    _availabilityViewModel.getAvailabilityList(request);
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
                               ? const Expanded(
                               child: Center(child: CircularProgressIndicator()))
                               : _isErrorInApi
                               ? Expanded(
                               child: ErrorMessageWidget(label: _errorMsg!))
                               : Expanded(
                               flex: 1,
                               child: RefreshIndicator(
                                 onRefresh: () => _availabilityViewModel
                                     .getAvailabilityList(request),
                                 child: Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: ListView.builder(
                                       itemCount: availabilities.length,
                                       itemBuilder: (context, index) =>
                                           listItem(availabilities[index]),
                                     )),
                               )),
                         ],)
                   )




                   )]))),
    );
  }

  listItem(AvailabilityRequest item) {
    var startDate = Controller().getServerDateFormated(item.startDate!);
    var endDate = "";
    if (item.endDate != null) {
      endDate = Controller().getServerDateFormated(item.endDate!);
    }

    return Card(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          color: item.status == ConstantData.pending
                              ? claimedShiftColor.withOpacity(0.1)
                              : item.status == ConstantData.approved
                                  ? claimedShiftApprovedColor.withOpacity(0.1)
                                  : claimedShiftRejectColor.withOpacity(0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextWidget(

                                text: Controller().convertStringDate(
                                    item.requestDate.toString(), "day"),
                                color: item.status == ConstantData.pending
                                    ? claimedShiftColor
                                    : item.status == ConstantData.approved
                                        ? claimedShiftApprovedColor
                                        : claimedShiftRejectColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextWidget(
                                text: Controller().convertStringDate(
                                    item.requestDate.toString(), "date"),
                                fontWeight: FontWeight.bold,
                                color: item.status == ConstantData.pending
                                    ? claimedShiftColor
                                    : item.status == ConstantData.approved
                                        ? claimedShiftApprovedColor
                                        : claimedShiftRejectColor,
                                size: 28,
                              ),
                            const  SizedBox(
                                height: 5,
                              ),
                              CustomTextWidget(
                                textAlign: TextAlign.center,
                                text: "${Controller().convertStringDate(
                                        item.requestDate.toString(), "month")}, ${Controller().convertStringDate(
                                        item.requestDate.toString(), "year")}",
                                color: item.status == ConstantData.pending
                                    ? claimedShiftColor
                                    : item.status == ConstantData.approved
                                        ? claimedShiftApprovedColor
                                        : claimedShiftRejectColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ],
                          ))),
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createRowDate("Title: ", item.title),
                            endDate.isNotEmpty
                                ? Column(
                                    children: [
                                      createRowDate("Start Date: ", startDate),
                                      createRowDate("End Date: ", startDate),
                                    ],
                                  )
                                : createRowDate("Effective Date: ", startDate),
                            createRowDate("Status: ", item.status),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                         const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ViewAvailability(
                                  availabilityRequest: item,
                                  isEditableView: false));
                            },
                            child: TextColorContainer(
                                label: "View Details",
                                color: primaryColor,
                                icon: Icons.remove_red_eye),
                          ),
                       const   SizedBox(
                            height: 15,
                          ),
                          item.status == ConstantData.pending ?
                          InkWell(
                            onTap: () {
                              Controller().showConfirmationMsgDialog(
                                  context,
                                  "Confirm",
                                  "Are you sure you want to delete?",
                                  "Yes", (value) {
                                if (value) {
                                  setState(() {
                                    isUpdateClick = true;
                                  });

                                  _progressDialog?.showLoadingDialog();
                                  _availabilityViewModel
                                      .deleteAvailabilityRequest(
                                          item.code.toString());
                                  deletedItemRequest = item;
                                }
                              });
                            },
                            child: TextColorContainer(
                              label: "Delete",
                              color: claimedShiftRejectColor,
                              icon: Icons.delete,
                            ),
                          )
                          :Center(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget createRowDate(String title, String? value) {
    return Column(
      children: [
SizedBox(height: 3,),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomTextWidget(text: title, fontWeight: FontWeight.bold,size: 12,),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: CustomTextWidget(
                    size: 12,
                    text: value,
                    color: Colors.grey,

                  )),
            ),
          ],
        ),
      ],
    );
  }

  void changeButtonState(int status) {
    setState(() {
      buttonState = status;
    });

    request = ClaimShiftHistoryRequest();
    DateTime now = DateTime.now();
    if (status == 0) {
      var startDate =  DateTime(now.year, now.month, 1);
      var endDate =
           DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    } else if (status == 1) {
      var startDate =  DateTime(now.year, now.month - 2, 1);
      var endDate =
           DateTime(now.year, now.month - 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    } else if (status == 2) {
      var startDate =  DateTime(now.year, 1, 1);
      var endDate =
           DateTime(now.year, now.month + 1, 0); //this month last date
      request.start_date = Controller().getConvertedDate(startDate);
      request.end_date = Controller().getConvertedDate(endDate);
    }

    if (status < 3) {
      setState(() {
        _isFirstLoadRunning = true;
        _isErrorInApi = false;
        _availabilityViewModel.getAvailabilityList(request);
      });
    }
  }
}

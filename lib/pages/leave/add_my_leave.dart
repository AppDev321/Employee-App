import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/response/leave_list.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../bloc/connected_bloc.dart';
import '../../data/drawer_items.dart';
import '../../widget/dialog_builder.dart';
import '../../utils/controller.dart';
import '../../view_models/leave_list_vm.dart';
import '../../widget/custom_comment_box.dart';
import '../../widget/custom_drop_down_widget.dart';
import '../../widget/custom_edit_text_widget.dart';
import '../../widget/date_picker_widget.dart';
import '../../widget/internet_not_available.dart';
import '../login/login.dart';

class AddLeave extends StatefulWidget {
  final List<DropMenuItems>? leaveTypes;

  const AddLeave({Key? key, @required this.leaveTypes}) : super(key: key);

  @override
  State<AddLeave> createState() => AddLeaveStateful();
}

class AddLeaveStateful extends State<AddLeave> {

  String? _errorMsg = "";
  CalendarController _controller = CalendarController();
  TextEditingController descController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
   DateTime startDate = DateTime.now(),endDate=DateTime.now();
  late LeaveListViewModel _leaveListViewModel;
  DialogBuilder? _progressDialog;
  int leaveTypeId= 1;
  BuildContext? _dialogContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();





    _leaveListViewModel = LeaveListViewModel();

    _leaveListViewModel.addListener(() {

      _progressDialog?.hideOpenDialog();

      var checkErrorApiStatus = _leaveListViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _errorMsg = _leaveListViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
          else
            {

              Controller().showToastMessage(context, _errorMsg!);
            }
        });
      } else {
        setState(() {
          _errorMsg = "";
        });

      Controller().showToastMessage(context, "Leave Request submitted successfully");
Navigator.pop(context);
      }
    });



  }

  @override
  Widget build(BuildContext context) {
    _dialogContext = context;
    if(_progressDialog == null)
      {
        _progressDialog =  DialogBuilder(_dialogContext!);
        _progressDialog?.initiateLDialog('Please wait..');
      }


    return Scaffold(
      appBar: AppBar(
        title: const Text(menuLeave),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 10, top: 10, right: 10),
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

              CustomTextWidget(text: "Leave Request", size: 25),
              SizedBox(
                height: 20,
              ),
              CustomTextWidget(text: "Leave Type:",fontWeight: FontWeight.bold,),
              CustomDropDownWidget(
                spinnerItems: widget.leaveTypes!,
                onClick: (data) {

                  leaveTypeId = data.id!;

                },
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DatePickerWidget(
                    selectedDate: DateTime.now(),
                    label: "From Date",
                    onDateChange: (value) {
                      setState(() {
                       startDate = value;
                      });
                    },
                  ),

                  DatePickerWidget(
                    selectedDate: DateTime.now(),
                    label: "To Date",
                    onDateChange: (value) {
                      setState(() {
                        endDate  = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(
                height: 10,
              ),

              CustomCommentBox(label:"Subject" ,hintMessage: "Enter your subject",controller: subjectController),

              SizedBox(
                height: 10,
              ),
              CustomCommentBox(label:"Description" ,hintMessage: "Enter your description",controller: descController),

              SizedBox(
                height: 20,
              ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                     Expanded(
                       child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey),
                              textStyle:
                              MaterialStateProperty.all(TextStyle(fontSize: 12))),
                          child: Text('Cancel'),
                        ),
                     ),

                    SizedBox(
                      width: 30,
                    ),
                        Expanded(

                      child: ElevatedButton(
                        onPressed: () {
                          if(_datesCheck())
                            {

                              _progressDialog?.showLoadingDialog();
                              var request = LeaveRequest();
                              request.dateTo = Controller().getConvertedDate(endDate);
                              request.dateFrom =  Controller().getConvertedDate(startDate);
                              request.leaveType =leaveTypeId.toString();
                              request.description = descController.text;
                              request.subject =subjectController.text;
                              _leaveListViewModel.saveLeaveRequest(request);

                            }
                          else
                            {
                              Controller().showToastMessage(context, "End date must be greater than leave start date");
                            }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                            textStyle:
                            MaterialStateProperty.all(TextStyle(fontSize: 12))),
                        child: Text('Save'),
                      ),
                    ),

                  ]),





            ],
          ),
        ),
      ),
    );
  }


  bool _datesCheck()
  {
    if(endDate.isAfter(startDate) || endDate== startDate)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

}

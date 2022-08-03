import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/strings.dart';
import 'package:hnh_flutter/repository/model/request/leave_save_request.dart';
import 'package:hnh_flutter/repository/model/request/overtime_save_request.dart';
import 'package:hnh_flutter/repository/model/response/leave_list.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils/controller.dart';
import '../../view_models/leave_list_vm.dart';
import '../../view_models/overtime_vm.dart';
import '../../widget/custom_comment_box.dart';
import '../../widget/custom_drop_down_widget.dart';
import '../../widget/custom_edit_text_widget.dart';
import '../../widget/date_picker_widget.dart';
import '../../widget/dialog_builder.dart';
import '../login/login.dart';

class AddOverTime extends StatefulWidget {


  const AddOverTime({Key? key}) : super(key: key);

  @override
  State<AddOverTime> createState() => AddLeaveStateful();
}

class AddLeaveStateful extends State<AddOverTime> {
  String? _errorMsg = "";
  TextEditingController hourController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  DateTime overtimeDate = DateTime.now();
  late OvertimeViewModel _overtimeViewModel;
  DialogBuilder? _progressDialog;
  int leaveTypeId = 1;
  BuildContext? _dialogContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _overtimeViewModel = OvertimeViewModel();


    _overtimeViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();
      var checkErrorApiStatus = _overtimeViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _errorMsg = _overtimeViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          } else {
            Controller().showToastMessage(context, _errorMsg!);
          }
        });
      } else {
        setState(() {
          _errorMsg = "";
        });


      }

      var overTimeRequestStatus = _overtimeViewModel.getOverTimeStatus();
      if(!overTimeRequestStatus)
      {
        _errorMsg = _overtimeViewModel.getErrorMsg();
        Controller().showToastMessage(context, _errorMsg!);
      }
      else {
        Controller().showToastMessage(
            context, "Request submitted successfully");
        Get.back();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(ConstantData.overTime),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(text: "Overtime Request", size: 25),
            SizedBox(
              height: 20,
            ),
            DatePickerWidget(
              selectedDate: DateTime.now(),
              label: "Date:",
              onDateChange: (value) {
                setState(() {
                  overtimeDate = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextWidget(text: "Hour:",fontWeight: FontWeight.bold),
            SizedBox(
              height: 10,
            ),
            CustomEditTextWidget(text: "Enter your hour",controller:hourController ,isNumberField: true),
            SizedBox(
              height: 10,
            ),
            CustomCommentBox(
                label: "Reason:",
                hintMessage: "Enter your description",
                controller: reasonController),
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 12))),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {

                          _progressDialog?.showLoadingDialog();
                          var request = OvertimeRequest();
                          request.date = Controller().getConvertedDate(overtimeDate);
                          request.hour = leaveTypeId.toString();
                          request.reason = reasonController.text;

                          _overtimeViewModel.saveOverTimeRequest(request);

                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 12))),
                      child: Text('Save'),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }


}

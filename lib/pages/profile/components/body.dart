import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/view_models/profile_vm.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../bloc/connected_bloc.dart';
import '../../../utils/controller.dart';
import '../../../widget/dialog_builder.dart';
import '../../../widget/internet_not_available.dart';
import '../../login/login.dart';
import '../user_detail.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';


class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Body();
  }
}


class _Body extends State<Body> {
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  DialogBuilder? _progressDialog;
  BuildContext? _dialogContext;

  late ProfileViewModel _profileViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileViewModel = ProfileViewModel();
    _profileViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();
      
      var isError =
      _profileViewModel.getIsErrorRecevied();
      if (isError) {
        String msg = _profileViewModel.getErrorMsg();
        Controller().showMessageDialog( msg,"Error");
      } else {
        Controller().showMessageDialog( "Your password has been updated successfully","Hey");
         Navigator.pop(context);

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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
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
          SizedBox(height: 5),
          ProfilePic(),

          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {
              Get.to(()=>MyAccount())
            },
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Change Password",
            icon: "assets/icons/ic_password.svg",
            press: () {
              _showChangePassword(context);
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              Controller().logoutUser();
            },
          ),
        ],
      ),
    );
  }

  _showChangePassword(BuildContext context) {


    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      // set this when inner content overflows, making RoundedRectangleBorder not working as expected
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white12,
          child: Center(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: CustomTextWidget(
                      text: "Password Change",
                      fontWeight: FontWeight.bold,
                      size: 18,
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: CustomEditTextWidget(
                          text: "Old Password",
                          isPasswordField: true,
                          controller: _oldPassword,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: CustomEditTextWidget(
                            text: "New Password",
                            isPasswordField: true,
                            controller: _newPassword,
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: CustomEditTextWidget(
                            text: "Confirm Password",
                            isPasswordField: true,
                            controller: _confirmPassword,
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: CustomTextWidget(
                              text:
                                  "Password must be 8 characters long and one uppercase,lowercase,symbol and number")),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: Colors.red,
                            onPressed: () {

                              var oldPass = Controller()
                                  .validatePassword(_oldPassword.text);
                              var newPass = Controller()
                                  .validatePassword(_newPassword.text);
                              var conPass = Controller()
                                  .validatePassword(_confirmPassword.text);

               //  if (oldPass && newPass && conPass) {
                              _progressDialog?.showLoadingDialog();
                                var request = ChangePasswordRequest();
                                request.currentPassword = _oldPassword.text;
                                request.newPassword = _newPassword.text;
                                request.newConfirmPassword =  _confirmPassword.text;
                                _profileViewModel.changePasswordRequest(request);

                     /*  } else {

                       Controller().showMessageDialog(
                                    "Please enter valid password","Error");
                          }   */
                            },
                            child: Center(
                              child: CustomTextWidget(
                                text: "SAVE PASSWORD",
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



}

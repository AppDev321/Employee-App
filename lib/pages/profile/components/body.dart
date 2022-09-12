import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/dashboard/dashboard.dart';
import 'package:hnh_flutter/pages/notification_history/notification_list.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/view_models/profile_vm.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../bloc/connected_bloc.dart';
import '../../../utils/controller.dart';
import '../../../widget/dialog_builder.dart';
import '../../../widget/internet_not_available.dart';
import '../../login/login.dart';
import '../profile_screen.dart';
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

String imageLinkUser ="";

bool isPasswordUpdateCalled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileViewModel = ProfileViewModel();
    _profileViewModel.getUserImageURLPreferecne();
    _profileViewModel.addListener(() {
      _progressDialog?.hideOpenDialog();
        setState(() {
          imageLinkUser = _profileViewModel.userProfileImage;

        });


      if(isPasswordUpdateCalled) {
        var isError =
        _profileViewModel.getIsErrorRecevied();
        if (isError) {
          String msg = _profileViewModel.getErrorMsg();
          Controller().showToastMessage(context, msg);
        } else {
          Navigator.pop(context);
          Controller().showToastMessage(
              context, "Your password has been updated successfully");
        }
        isPasswordUpdateCalled = false;
      }

    });


    FBroadcast.instance().register(
      Controller().userKey,   (value, callback) {
      setState(() {
        setState(() {
          Controller().setUserProfilePic(value);
          imageLinkUser =value;

        });

      });
    }

    );


  }



  @override
  Widget build(BuildContext context) {
    _dialogContext = context;

    if (_progressDialog == null) {
      _progressDialog = DialogBuilder(_dialogContext!);
      _progressDialog?.initiateLDialog('Please wait..');
    }

    return Column(
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
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [


              SizedBox(height: 5),
              ProfilePic(profileImageUrl: imageLinkUser,isEditable:false),

              SizedBox(height: 20),
              SettingMenu(
                text: "My Account",
                icon: "assets/icons/User Icon.svg",
                press: () => {
                  Get.to(()=>MyAccount())
                },
              ),
              SettingMenu(
                text: "Notifications",
                icon: "assets/icons/Bell.svg",
                press: () {
                 Get.to(()=>NotificationList());
                },
              ),
             /* ProfileMenu(
                text: "Settings",
                icon: "assets/icons/Settings.svg",
                press: () {},
              ),*/
              SettingMenu(
                text: "Change Password",
                icon: "assets/icons/ic_password.svg",
                press: () {
                  _showChangePassword(context);
                },
              ),
              SettingMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () {
                  Controller().logoutUser();
                },
              ),
            ],
          ),
        ),
      ],
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
                          child:

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.red,
                                primary: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                shape:const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                )),

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
                                isPasswordUpdateCalled = true;
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

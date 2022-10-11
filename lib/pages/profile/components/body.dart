import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/pages/notification_history/notification_list.dart';
import 'package:hnh_flutter/repository/model/request/change_password_request.dart';
import 'package:hnh_flutter/view_models/profile_vm.dart';
import 'package:hnh_flutter/widget/custom_edit_text_widget.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../../bloc/connected_bloc.dart';
import '../../../utils/controller.dart';
import '../../../widget/custom_radio_group_widget.dart';
import '../../../widget/dialog_builder.dart';
import '../../../widget/internet_not_available.dart';
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
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  DialogBuilder? _progressDialog;
  BuildContext? _dialogContext;
  String isBiometricEnabled = "Disable";

  late ProfileViewModel _profileViewModel;

  String imageLinkUser = "";

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

    return SingleChildScrollView(
        child: Column(
      children: [
        BlocBuilder<ConnectedBloc, ConnectedState>(builder: (context, state) {
          if (state is ConnectedFailureState) {
            return const InternetNotAvailable();
          } else {
            return Container();
          }
        }),
        Column(
          children: [
            const SizedBox(height: 5),
            ProfilePic(profileImageUrl: imageLinkUser, isEditable: false),
            const SizedBox(height: 20),
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
                  Get.to(() => const NotificationList());
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
              text: "Enable Biometric",
              icon: "assets/icons/ic_password.svg",
              press: () {
                _showBiometricSheet(context);
              },
            ),
            Visibility(
                visible: false,
                child: SettingMenu(
                  text: "Theme",
                  icon: "assets/icons/ic_theme.svg",
                  press: () {
                    _showChangePassword(context);
                  },
                )),
            SettingMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                Controller().logoutUser();
              },
            ),
          ],
        ),
      ],
    ));
  }

  _showChangePassword(BuildContext context) {


    showModalBottomSheet<void>(
      context: context,
      backgroundColor: cardThemeBaseColor,
      isScrollControlled: false,
      // set this when inner content overflows, making RoundedRectangleBorder not working as expected
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white12,
            child: Center(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: const CustomTextWidget(
                        text: "Password Change",
                        fontWeight: FontWeight.bold,
                        size: 18,
                      )),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: CustomEditTextWidget(
                            text: "Old Password",
                            isPasswordField: true,
                            controller: _oldPassword,
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: CustomEditTextWidget(
                              text: "New Password",
                              isPasswordField: true,
                              controller: _newPassword,
                            )),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: CustomEditTextWidget(
                              text: "Confirm Password",
                              isPasswordField: true,
                              controller: _confirmPassword,
                            )),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: CustomTextWidget(
                                text:
                                    "Password must be 8 characters long and one uppercase,lowercase,symbol and number")),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.red,
                                  primary: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
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
                                request.newConfirmPassword =
                                    _confirmPassword.text;
                                _profileViewModel
                                    .changePasswordRequest(request);
                                isPasswordUpdateCalled = true;
                                /*  } else {

                         Controller().showMessageDialog(
                                      "Please enter valid password","Error");
                            }   */
                              },
                              child: const Center(
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
          ),
        );
      },
    );
  }

  _showBiometricSheet(BuildContext context) async {
    List<RadioItem> item = [];
    item.add(RadioItem("Disable", 0));
    item.add(RadioItem("Enable", 1));

    var initialPos = await Controller().getBiometericStatus() == true ? 1 : 0;

    showModalBottomSheet(
        context: context,
        backgroundColor: cardThemeBaseColor,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white12,
              child: Wrap(
                children: <Widget>[
                  Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: const CustomTextWidget(
                        text: "Finger Print Setting",
                        fontWeight: FontWeight.bold,
                        size: 18,
                      )),
                  CustomRadioGroupWidget(
                      initialIndex: initialPos,
                      items: item,
                      onValueChange: (item) {

                        if (item.index == 0) {
                          Controller().setBiometericStatus(false);
                        } else {
                          Controller().setBiometericStatus(true);
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }
  //Enable bio
}

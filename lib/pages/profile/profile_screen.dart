import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hnh_flutter/custom_style/colors.dart';
import 'package:hnh_flutter/repository/model/response/user_profile.dart';
import 'package:hnh_flutter/view_models/profile_vm.dart';
import 'package:hnh_flutter/widget/custom_text_widget.dart';

import '../../bloc/connected_bloc.dart';
import '../../custom_style/strings.dart';
import '../../utils/controller.dart';
import '../../widget/dialog_builder.dart';
import '../../widget/error_message.dart';
import '../../widget/internet_not_available.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool showPassword = false;
  late ProfileViewModel _profileViewModel;
  late Profile profileDetail;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emergencyController = TextEditingController();
  TextEditingController emergencyAddressController = TextEditingController();
  TextEditingController emergencyRelationController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  String userImageURL="";

  bool _isFirstLoadRunning = false;
  bool _isErrorInApi = false;
  String? _errorMsg = "";

  DialogBuilder? _progressDialog;
  BuildContext? _dialogContext;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _isFirstLoadRunning = true;
      _isErrorInApi = false;
    });

    _profileViewModel = ProfileViewModel();
    _profileViewModel.getProfileDetail();

    _profileViewModel.addListener(() {

      _progressDialog?.hideOpenDialog();


      var checkErrorApiStatus = _profileViewModel.getIsErrorRecevied();
      if (checkErrorApiStatus) {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = _profileViewModel.getErrorMsg();
          if (_errorMsg!.contains(ConstantData.unauthenticatedMsg)) {
            Controller().logoutUser();
          }
        });
      } else {
        setState(() {
          _isFirstLoadRunning = false;
          _isErrorInApi = checkErrorApiStatus;
          _errorMsg = "";
        });
        profileDetail = _profileViewModel.getUserProfile();
        if(profileDetail.profileURL != null)
        userImageURL = profileDetail.profileURL.toString();
      }


      var isProfileUpdated = _profileViewModel.getProileUpdateStatus();
      if(isProfileUpdated)
        {
          /// send msg
      //    FBroadcast.instance().broadcast(Controller().notificationBroadCast, value: userImageURL);
          FBroadcast.instance().broadcast(
            Controller().userKey,
            value:userImageURL,
            persistence: true,
          );


          Navigator.pop(context);
         Controller().showToastMessage(context,"Profile Updated Successfully");
        }
      else
        {
          if(_profileViewModel.getErrorMsg().isNotEmpty)
          Controller().showToastMessage(context, _profileViewModel.getErrorMsg());
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
        title: Text("Profile"),
      ),
      body: Column(
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



          _isFirstLoadRunning
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : _isErrorInApi
                  ? Expanded(child: ErrorMessageWidget(label: _errorMsg!))
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh:  _profileViewModel.getProfileDetail ,
                        child: Container(
                          padding: EdgeInsets.only(left: 16, top: 0, right: 16),
                          child:  ListView(
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 4, color: primaryColor),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: Offset(0, 10))
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  userImageURL.isEmpty?Controller().defaultPic:userImageURL,
                                                ))),
                                      ),
                                      Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 4, color: primaryColor),
                                              color: primaryColor,
                                            ),
                                            child: InkWell(
                                              onTap: (){
                                  _profileViewModel.showPicker(context,(value){
                                    _profileViewModel.uploadProfileImage(value,(isUploaded){
                                    //File path
                                    },(imageUrl){
                                        print(imageUrl);
                                        setState(() {
                                          userImageURL = imageUrl;
                                        });

                                    });



                                  });
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                buildTextField(
                                    firstNameController,
                                    "First Name",
                                    profileDetail.firstName ?? "N/A",
                                    false,
                                    false),
                                buildTextField(
                                    lastNameController,
                                    "Last Name",
                                    profileDetail.lastName ?? "N/A",
                                    false,
                                    false),
                                buildTextField(
                                    emailController,
                                    "Personal Email",
                                    profileDetail.personalEmail ?? "N/A",
                                    false,
                                    false),
                                buildTextField(
                                    currentAddressController,
                                    "Current Address",
                                    profileDetail.currentAddress ?? "N/A",
                                    false,
                                    false),
                                buildTextField(
                                    permanentAddressController,
                                    "Permanent Address",
                                    profileDetail.permanentAddress ?? "N/A",
                                    false,
                                    false),
                                buildTextField(cityController, "City",
                                    profileDetail.city ?? "N/A", false, false),
                                buildTextField(
                                    phoneController,
                                    "Contact Number",
                                    profileDetail.contactNumber ?? "N/A",
                                    false,
                                    true),
                                buildTextField(
                                    emergencyController,
                                    "Emergency Number",
                                    profileDetail.emergencyContact ?? "N/A",
                                    false,
                                    true),
                                buildTextField(
                                    emergencyAddressController,
                                    "Emergency Address",
                                    profileDetail.emergencyAddress ?? "N/A",
                                    false,
                                    false),
                                buildTextField(
                                    emergencyRelationController,
                                    "Emergency Contact Relation",
                                    profileDetail.emergencyContactRelation ?? "N/A",
                                    false,
                                    false),

                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width:120,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.grey),
                                            textStyle:
                                            MaterialStateProperty.all(TextStyle(fontSize: 12))),
                                        child: Text('Cancel'),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width:120,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _progressDialog?.showLoadingDialog();

                                          var request = profileDetail;
                                          request.firstName = getStringValue(firstNameController,request.firstName ?? 'N/A');
                                          request.lastName = getStringValue(lastNameController,request.lastName ?? 'N/A');
                                          request.city = getStringValue(cityController,request.city ?? 'N/A');
                                          request.contactNumber = getStringValue(phoneController,request.contactNumber ?? 'N/A');
                                          request.emergencyContact = getStringValue(emergencyController,request.emergencyContact ??   'N/A');
                                          request.permanentAddress = getStringValue(permanentAddressController,request.permanentAddress ?? 'N/A');
                                          request.currentAddress = getStringValue(currentAddressController,request.currentAddress ?? 'N/A');
                                          request.personalEmail = getStringValue(emailController,request.personalEmail ?? 'N/A');
                                          request.emergencyAddress = getStringValue(emergencyAddressController,request.emergencyAddress ?? 'N/A');
                                          request.emergencyContactRelation = getStringValue(emergencyRelationController,request.emergencyContactRelation ?? 'N/A');
                                          request.profileURL = userImageURL;

                                          _profileViewModel.updateUserProfile(request);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(primaryColor),
                                            textStyle:
                                            MaterialStateProperty.all(TextStyle(fontSize: 12))),
                                        child: Text('Save'),
                                      ),
                                    ),



                                  ],
                                ),

                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                      ),
                      ),

        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText,
      String placeholder, bool isPasswordTextField, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(fontSize: 14, color: Colors.black)),
      ),
    );
  }



  String getStringValue(TextEditingController value,String defaultValue)
  {
    return value.text.toString().isEmpty ?  defaultValue : value.text.toString();

  }
}



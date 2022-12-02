import 'package:json_annotation/json_annotation.dart';

import 'claimed_shift_list.dart';

part 'user_profile.g.dart';

//done this file

@JsonSerializable()
class UserProfileDetail {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  UserProfileDetail({this.code, this.message, this.data, this.errors});

  UserProfileDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Profile? profile;

  Data({this.profile});

  Data.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? contactNumber;
  String? personalEmail;
  String? currentAddress;
  String? permanentAddress;
  String? city;
  String? emergencyContact;
  String? emergencyAddress;
  String? emergencyContactRelation;
  String? profileURL;

  Profile(
      {this.firstName,
      this.middleName,
      this.lastName,
      this.contactNumber,
      this.personalEmail,
      this.currentAddress,
      this.permanentAddress,
      this.city,
      this.emergencyContact,
      this.emergencyAddress,
      this.emergencyContactRelation,
      this.profileURL});

  Profile.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    contactNumber = json['contact_number'];
    personalEmail = json['personal_email'];
    currentAddress = json['current_address'];
    permanentAddress = json['permanent_address'];
    city = json['city'];
    emergencyContact = json['emergency_contact'];
    emergencyAddress = json['emergency_address'];
    emergencyContactRelation = json['emergency_contact_relation'];
    profileURL =json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['contact_number'] = this.contactNumber;
    data['personal_email'] = this.personalEmail;
    data['current_address'] = this.currentAddress;
    data['permanent_address'] = this.permanentAddress;
    data['city'] = this.city;
    data['emergency_contact'] = this.emergencyContact;
    data['emergency_address'] = this.emergencyAddress;
    data['emergency_contact_relation'] = this.emergencyContactRelation;
    data['profile_url']=this.profileURL;
    return data;
  }
}

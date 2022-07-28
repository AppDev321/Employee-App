
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'claimed_shift_list.g.dart';

//done this file

@JsonSerializable()
class ClaimShiftListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  ClaimShiftListResponse({this.code, this.message, this.data, this.errors});

  ClaimShiftListResponse.fromJson(Map<String, dynamic> json) {
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

class Errors {
  String? message;

  Errors({this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Claims>? claims;

  Data({this.claims});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['claims'] != null) {
      claims = <Claims>[];
      json['claims'].forEach((v) { claims!.add(new Claims.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.claims != null) {
      data['claims'] = this.claims!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Claims {
  int? id;
  String? status;
  String? managedBy;
  Shifts? shift;

  Claims({this.id, this.status, this.managedBy, this.shift});

  Claims.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    managedBy = json['managed_by'];
    shift = json['shift'] != null ? new Shifts.fromJson(json['shift']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['managed_by'] = this.managedBy;
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    return data;
  }
}


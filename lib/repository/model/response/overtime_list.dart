
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'overtime_list.g.dart';

//done this file

@JsonSerializable()
class OvertimeListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  OvertimeListResponse({this.code, this.message, this.data, this.errors});

  OvertimeListResponse.fromJson(Map<String, dynamic> json) {
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
  List<OvertimeHistory>? overtimeHistory;

  Data({this.overtimeHistory});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['overtime_history'] != null) {
      overtimeHistory = <OvertimeHistory>[];
      json['overtime_history'].forEach((v) {
        overtimeHistory!.add(new OvertimeHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.overtimeHistory != null) {
      data['overtime_history'] =
          this.overtimeHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OvertimeHistory {
  int? id;
  String? date;
  String? hour;
  String? reason;
  String? status;
  String? managedBy;


  OvertimeHistory({this.id, this.date, this.hour, this.reason, this.status,this.managedBy});

  OvertimeHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    hour = json['hour'];
    reason = json['reason'];
    status = json['status'];
    managedBy = json['managed_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['hour'] = this.hour;
    data['reason'] = this.reason;
    data['status'] = this.status;
    data['managed_by'] =   managedBy ;
    return data;
  }
}

import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leave_list.g.dart';

//done this file

@JsonSerializable()
class LeaveListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  LeaveListResponse({this.code, this.message, this.data, this.errors});

  LeaveListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Leaves>? leaves;
  List<DropMenuItems>? leaveTypes;

  Data({this.leaves, this.leaveTypes});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(new Leaves.fromJson(v));
      });
    }
    if (json['leave_types'] != null) {
      leaveTypes = <DropMenuItems>[];
      json['leave_types'].forEach((v) {
        leaveTypes!.add(new DropMenuItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaves != null) {
      data['leaves'] = this.leaves!.map((v) => v.toJson()).toList();
    }
    if (this.leaveTypes != null) {
      data['leave_types'] = this.leaveTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Leaves {
  int? id;
  String? dateFrom;
  String? dateTo;
  String? createdAt;
  int? days;
  String? managedBy;
  String? subject;
  String? status;
  String? leaveType;

  Leaves(
      {this.id,
        this.dateFrom,
        this.dateTo,
        this.createdAt,
        this.days,
        this.managedBy,
        this.subject,
        this.status,
        this.leaveType});

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    createdAt = json['created_at'];
    days = json['days'];
    managedBy = json['managed_by'];
    subject = json['subject'];
    status = json['status'];
    leaveType = json['leave_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['created_at'] = this.createdAt;
    data['days'] = this.days;
    data['managed_by'] = this.managedBy;
    data['subject'] = this.subject;
    data['status'] = this.status;
    data['leave_type'] = this.leaveType;
    return data;
  }
}

class DropMenuItems {
  int? id;
  String? name;

  DropMenuItems({this.id, this.name});

  DropMenuItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

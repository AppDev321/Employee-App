
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:hnh_flutter/repository/model/response/report_attendance_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_dashboard.g.dart';

//done this file

@JsonSerializable()
class GetDashBoardResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GetDashBoardResponse({this.code, this.message, this.data, this.errors});

  GetDashBoardResponse.fromJson(Map<String, dynamic> json) {
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
  User? user;
  Shifts? shift;
  Stats? stats;
  bool? checkedIn;
  Attendance? attendance;

  Data({this.user, this.shift, this.stats,this.checkedIn,this.attendance});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shift = json['shift'] != null ? new Shifts.fromJson(json['shift']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
    attendance = json['attendance'] != null ? new Attendance.fromJson(json['attendance']) : null;
    checkedIn = json['checked_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats!.toJson();
    }
    data['checked_in'] = this.checkedIn;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? profileURL;

  User({this.name,this.profileURL});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileURL =json['profile_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_url']=this.profileURL;
    return data;
  }
}

class Stats {
  int? leaves;
  int? totalShifts;
  int? totalTime;

  Stats({this.leaves, this.totalShifts, this.totalTime});

  Stats.fromJson(Map<String, dynamic> json) {
    leaves = json['leaves'];
    totalShifts = json['total_shifts'];
    totalTime = json['total_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leaves'] = this.leaves;
    data['total_shifts'] = this.totalShifts;
    data['total_time'] = this.totalTime;
    return data;
  }
}
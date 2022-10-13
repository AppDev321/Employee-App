
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_attendance_response.g.dart';

//done this file

@JsonSerializable()
class AttendanceReportResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;


  AttendanceReportResponse({this.code, this.message, this.data, this.errors});

  AttendanceReportResponse.fromJson(Map<String, dynamic> json) {
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
  String? startDate;
  String? endDate;
  List<Attendance>? attendance;

  Data({this.startDate, this.endDate, this.attendance});

  Data.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  int? id;
  String? date;
  String? dayNum;
  String? dayName;
  String? timeIn;
  String? timeOut;
  String? duration;
  int? totalTime;

  Attendance(
      {this.id,
        this.date,
        this.dayNum,
        this.dayName,
        this.timeIn,
        this.timeOut,
        this.duration,
        this.totalTime});

  Attendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dayNum = json['day_num'];
    dayName = json['day_name'];
    timeIn = json['time_in'];
    timeOut = json['time_out'];
    duration = json['duration'];
    totalTime = json['total_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['day_num'] = this.dayNum;
    data['day_name'] = this.dayName;
    data['time_in'] = this.timeIn;
    data['time_out'] = this.timeOut;
    data['duration'] = this.duration;
    data['total_time'] = this.totalTime;
    return data;
  }
}
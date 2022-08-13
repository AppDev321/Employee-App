
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_lateness_response.g.dart';

//done this file

@JsonSerializable()
class LatenessReportResponse {
  int? code;
  String? message;
  LatenessData? data;
  List<Errors>? errors;

  LatenessReportResponse({this.code, this.message, this.data, this.errors});

  LatenessReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new LatenessData.fromJson(json['data']) : null;

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
class LatenessData {
  String? startDate;
  String? endDate;
  int? totalShifts;
  int? totalLates;
  String? latePercentage;
  int? totalTimeLate;
  int? lateAverage;

  LatenessData(
      {this.startDate,
        this.endDate,
        this.totalShifts,
        this.totalLates,
        this.latePercentage,
        this.totalTimeLate,
        this.lateAverage});

  LatenessData.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalShifts = json['total_shifts'];
    totalLates = json['total_lates'];
    latePercentage = json['late_percentage'];
    totalTimeLate = json['total_time_late'];
    lateAverage = json['late_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_shifts'] = this.totalShifts;
    data['total_lates'] = this.totalLates;
    data['late_percentage'] = this.latePercentage;
    data['total_time_late'] = this.totalTimeLate;
    data['late_average'] = this.lateAverage;
    return data;
  }
}

import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_leave_response.g.dart';

//done this file

@JsonSerializable()
class LeaveReportResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  LeaveReportResponse({this.code, this.message, this.data, this.errors});

  LeaveReportResponse.fromJson(Map<String, dynamic> json) {
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
  int? totalLeaves;
  List<ChartData>? leaveData;

  Data({this.startDate, this.endDate, this.totalLeaves, this.leaveData});

  Data.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalLeaves = json['total_leaves'];
    if (json['leave_data'] != null) {
      leaveData = <ChartData>[];
      json['leave_data'].forEach((v) {
        leaveData!.add(new ChartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_leaves'] = this.totalLeaves;
    if (this.leaveData != null) {
      data['leave_data'] = this.leaveData!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
class ChartData {
  String? name;
  int? count;

  ChartData({this.name, this.count});

  ChartData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}

import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
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

  Data({this.user, this.shift, this.stats});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shift = json['shift'] != null ? new Shifts.fromJson(json['shift']) : null;
    stats = json['stats'] != null ? new Stats.fromJson(json['stats']) : null;
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
    return data;
  }
}

class User {
  String? name;

  User({this.name});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
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
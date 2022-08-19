
import 'package:json_annotation/json_annotation.dart';

part 'get_shift_list.g.dart';

//done this file

@JsonSerializable()
class GetShiftListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GetShiftListResponse({this.code, this.message, this.data, this.errors});

  GetShiftListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Shifts>? shifts;
  List<Shifts>? openShifts;

  Data({this.shifts, this.openShifts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['shifts'] != null) {
      shifts = <Shifts>[];
      json['shifts'].forEach((v) {
        shifts!.add(new Shifts.fromJson(v));
      });
    }
    if (json['open_shifts'] != null) {
      openShifts = <Shifts>[];
      json['open_shifts'].forEach((v) {
        openShifts!.add(new Shifts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shifts != null) {
      data['shifts'] = this.shifts!.map((v) => v.toJson()).toList();
    }
    if (this.openShifts != null) {
      data['open_shifts'] = this.openShifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shifts {
  int? id;
  String? empName;
  String? designation;
  String? location;
  String? note;
  String? shiftBreak;
  String? shiftTime;
  String? date;
  String? vehicle;
  bool? claimed = false;
  bool? todayShift;

  Shifts(
      {this.id,
      this.empName,
      this.designation,
      this.location,
      this.note,
      this.shiftBreak,
      this.shiftTime,
      this.date,
        this.vehicle,
      this.claimed
      });

  Shifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    empName = json['emp_name'];
    designation = json['designation'];
    location = json['location'];
    note = json['note'];
    shiftBreak = json['break'];
    shiftTime = json['shift_time'];
    date = json['date'];
    claimed = json['claimed'];
    vehicle = json['vehicle'];
    todayShift = json['today_shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emp_name'] = this.empName;
    data['designation'] = this.designation;
    data['location'] = this.location;
    data['note'] = this.note;
    data['break'] = this.shiftBreak;
    data['shift_time'] = this.shiftTime;
    data['date'] = this.date;
    data['claimed'] = this.claimed;
    data['vehicle']=     vehicle ;
    data['today_shift'] = this.todayShift;
    return data;
  }
}

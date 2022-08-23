import 'package:json_annotation/json_annotation.dart';

part 'availability_request.g.dart';

@JsonSerializable()
class AvailabilityRequest {
  String? startDate;
  String? endDate;
  String? title;
  String? status;
 List<TimeSlot>? timeSlot;
  String? code;
  String? requestDate;

  AvailabilityRequest({this.startDate, this.endDate, this.title, this.timeSlot,this.code,this.requestDate});

  AvailabilityRequest.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    title = json['title'];
    status = json ['status'];
    requestDate = json['request_date'];
    code = json['code'];
    if (json['time_slot'] != null) {
      timeSlot = <TimeSlot>[];
      json['time_slot'].forEach((v) {
        timeSlot!.add(new TimeSlot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['title'] = this.title;
    data['request_date'] = this.requestDate;
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.timeSlot != null) {
      data['time_slot'] = this.timeSlot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {


  String? start;
  String? end;
  String? startHour;
  String? startMinute;
  String? endHour;
  String? endMinute;

  bool? isAvailable;
  bool? isAllDay = false;
  String? dayName;
  String? date;



  TimeSlot(
      {this.start,
        this.end,
        this.isAvailable,
        this.isAllDay,
        this.dayName});

  TimeSlot.fromJson(Map<String, dynamic> json) {
    start = json['start_time'];
    end = json['end_time'];

    startHour = json['startHour'];
    startMinute = json['startMinute'];
    endHour = json['endHour'];
    endMinute = json['endMinute'];


    isAvailable = json['isAvailable'];
    isAllDay = json['isAllDay'];
    dayName = json['dayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.start;
    data['end_time'] = this.end;

    data['startHour'] = this.startHour;
    data['startMinute'] = this.startMinute;
    data['endHour'] = this.endHour;
    data['endMinute'] = this.endMinute;


    data['isAvailable'] = this.isAvailable;
    data['isAllDay'] = this.isAllDay;
    data['dayName'] = this.dayName;
    return data;
  }
}
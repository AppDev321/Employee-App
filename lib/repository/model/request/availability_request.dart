import 'package:json_annotation/json_annotation.dart';

part 'availability_request.g.dart';

@JsonSerializable()
class AvailabilityRequest {
  String? startDate;
  String? endDate;
  String? title;
  List<TimeSlot>? timeSlot;

  AvailabilityRequest({this.startDate, this.endDate, this.title, this.timeSlot});

  AvailabilityRequest.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    title = json['title'];
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
    isAvailable = json['isAvailable'];
    isAllDay = json['isAllDay'];
    dayName = json['dayName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_time'] = this.start;
    data['end_time'] = this.end;
    data['isAvailable'] = this.isAvailable;
    data['isAllDay'] = this.isAllDay;
    data['dayName'] = this.dayName;
    return data;
  }
}
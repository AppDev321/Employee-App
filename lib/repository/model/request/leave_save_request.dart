import 'package:json_annotation/json_annotation.dart';

part 'leave_save_request.g.dart';

@JsonSerializable()
class LeaveRequest{
  String? dateFrom;
  String? dateTo;
  String? subject;
  String? description;
  String? leaveType;

  LeaveRequest(
      {this.dateFrom,
        this.dateTo,
        this.subject,
        this.description,
        this.leaveType});

  LeaveRequest.fromJson(Map<String, dynamic> json) {
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    subject = json['subject'];
    description = json['description'];
    leaveType = json['leave_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['leave_type'] = this.leaveType;
    return data;
  }
}
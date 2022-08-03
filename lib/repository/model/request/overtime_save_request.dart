import 'package:json_annotation/json_annotation.dart';

part 'overtime_save_request.g.dart';

@JsonSerializable()
class OvertimeRequest{
  String? date;
  String? hour;
  String? reason;


  OvertimeRequest(
      {this.date,
        this.hour,
        this.reason});

  OvertimeRequest.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    hour = json['hour'];
    reason = json['reason'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['hour'] = this.hour;
    data['reason'] = this.reason;

    return data;
  }
}
import 'package:json_annotation/json_annotation.dart';

part 'claim_shift_history_request.g.dart';

@JsonSerializable()
class ClaimShiftHistoryRequest{
  String? start_date;
  String? end_date;
  ClaimShiftHistoryRequest({this.start_date,this.end_date});

  ClaimShiftHistoryRequest.fromJson(Map<String, dynamic> json) {
    start_date = json['start_date'];
    end_date = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.start_date;
    data['end_date'] = this.end_date;
    return data;
  }
}
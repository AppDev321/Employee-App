import 'package:json_annotation/json_annotation.dart';
part 'claim_shift_request.g.dart';

@JsonSerializable()
class ClaimShiftRequest{
  String? openShiftId;

  ClaimShiftRequest({this.openShiftId});

  ClaimShiftRequest.fromJson(Map<String, dynamic> json) {
    openShiftId = json['open_shift_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_shift_id'] = this.openShiftId;
    return data;
  }
}
import 'package:json_annotation/json_annotation.dart';

part 'inspection_check_request.g.dart';

@JsonSerializable()
class CheckInspectionRequest {
  String? vehicleInspectionId;
  int? checkNo=0;

  CheckInspectionRequest({this.vehicleInspectionId, this.checkNo});

  CheckInspectionRequest.fromJson(Map<String, dynamic> json) {
    vehicleInspectionId = json['vehicle_inspection_id'];
    checkNo = json['check_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_inspection_id'] = this.vehicleInspectionId;
    data['check_no'] = this.checkNo;
    return data;
  }
}
import 'package:json_annotation/json_annotation.dart';

part 'vechicle_get_inspection_request.g.dart';

@JsonSerializable()
class VechicleInspectionRequest {
  String? vehicleId;

  VechicleInspectionRequest({this.vehicleId});

  VechicleInspectionRequest.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    return data;
  }
}
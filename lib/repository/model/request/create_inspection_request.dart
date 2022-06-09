import 'package:json_annotation/json_annotation.dart';

part 'create_inspection_request.g.dart';

@JsonSerializable()
class CreateInspectionRequest {
  String? vehicleId;
  String? type;
  String? date;
  String? odometerReading;

  CreateInspectionRequest(
      {this.vehicleId, this.type, this.date, this.odometerReading});

  CreateInspectionRequest.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    type = json['type'];
    date = json['date'];
    odometerReading = json['odometer_reading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['odometer_reading'] = this.odometerReading;
    return data;
  }
}

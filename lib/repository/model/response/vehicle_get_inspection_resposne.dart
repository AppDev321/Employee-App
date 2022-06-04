import 'package:json_annotation/json_annotation.dart';
part 'vehicle_get_inspection_resposne.g.dart';


@JsonSerializable()
class VehicleGetInspectionResponse {
  Vehicle? vehicle;

  VehicleGetInspectionResponse({this.vehicle});

  VehicleGetInspectionResponse.fromJson(Map<String, dynamic> json) {
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    return data;
  }
}

class Vehicle {
  int? id;
  int? employeeId;
  String? vrn;
  String? type;
  String? make;
  String? model;
  String? createdAt;
  String? updatedAt;
  List<Inspections>? inspections;

  Vehicle(
      {this.id,
        this.employeeId,
        this.vrn,
        this.type,
        this.make,
        this.model,
        this.createdAt,
        this.updatedAt,
        this.inspections});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vrn = json['vrn'];
    type = json['type'];
    make = json['make'];
    model = json['model'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['inspections'] != null) {
      inspections = <Inspections>[];
      json['inspections'].forEach((v) {
        inspections!.add(new Inspections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['vrn'] = this.vrn;
    data['type'] = this.type;
    data['make'] = this.make;
    data['model'] = this.model;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.inspections != null) {
      data['inspections'] = this.inspections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Inspections {
  int? id;
  int? employeeId;
  int? vehicleId;
  String? type;
  String? date;
  String? odometerReading;
  String? vehicleType;
  String? status;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  Inspections(
      {this.id,
        this.employeeId,
        this.vehicleId,
        this.type,
        this.date,
        this.odometerReading,
        this.vehicleType,
        this.status,
        this.isRead,
        this.createdAt,
        this.updatedAt});

  Inspections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vehicleId = json['vehicle_id'];
    type = json['type'];
    date = json['date'];
    odometerReading = json['odometer_reading'];
    vehicleType = json['vehicle_type'];
    status = json['status'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employee_id'] = this.employeeId;
    data['vehicle_id'] = this.vehicleId;
    data['type'] = this.type;
    data['date'] = this.date;
    data['odometer_reading'] = this.odometerReading;
    data['vehicle_type'] = this.vehicleType;
    data['status'] = this.status;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
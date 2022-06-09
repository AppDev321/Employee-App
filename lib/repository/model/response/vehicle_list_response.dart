import 'package:json_annotation/json_annotation.dart';
part 'vehicle_list_response.g.dart';


@JsonSerializable()

class Data {
  List<Vehicles>? vehicles;

  Data({this.vehicles});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(new Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Vehicles {
  int? id;
  int? employeeId;
  String? vrn;
  String? type;
  String? make;
  String? model;
  String? createdAt;
  String? updatedAt;

  Vehicles(
      {this.id,
        this.employeeId,
        this.vrn,
        this.type,
        this.make,
        this.model,
        this.createdAt,
        this.updatedAt});

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    vrn = json['vrn'];
    type = json['type'];
    make = json['make'];
    model = json['model'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}

class Errors {
  String? message;

  Errors({this.message});

  Errors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
class GetVehicleListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GetVehicleListResponse({this.code, this.message, this.data, this.errors});

  GetVehicleListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




import 'package:json_annotation/json_annotation.dart';

part 'save_inspection_check_api_response.g.dart';

//done this file

@JsonSerializable()
class SaveInspectionCheckResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  SaveInspectionCheckResponse({this.code, this.message, this.data, this.errors});

  SaveInspectionCheckResponse.fromJson(Map<String, dynamic> json) {
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

class Data {
  int? id;
  int? vehicleId;
  int? nextCheck;
  bool? completed;

  Data({this.id, this.vehicleId, this.nextCheck, this.completed});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    nextCheck = json['next_check'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_id'] = this.vehicleId;
    data['next_check'] = this.nextCheck;
    data['completed'] = this.completed;
    return data;
  }
}

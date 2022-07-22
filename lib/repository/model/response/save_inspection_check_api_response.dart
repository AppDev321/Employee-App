import 'package:json_annotation/json_annotation.dart';

part 'save_inspection_check_api_response.g.dart';

//done this file

@JsonSerializable()
class SaveInspectionCheckResponse
{
  int? code;
  String? message;
  String? data;
  List<Errors>? errors;

  SaveInspectionCheckResponse({this.code, this.message, this.data, this.errors});

  SaveInspectionCheckResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
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
    data['data'] = this.data;
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


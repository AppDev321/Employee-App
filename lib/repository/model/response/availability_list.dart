
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

import '../request/availability_request.dart';

part 'availability_list.g.dart';

//done this file

@JsonSerializable()
class AvailabilityListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  AvailabilityListResponse({this.code, this.message, this.data, this.errors});

  AvailabilityListResponse.fromJson(Map<String, dynamic> json) {
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
class Data {
  List<AvailabilityRequest>? availabilities;

  Data({this.availabilities});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['availabilities'] != null) {
      availabilities = <AvailabilityRequest>[];
      json['availabilities'].forEach((v) {
        availabilities!.add(new AvailabilityRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.availabilities != null) {
      data['availabilities'] =
          this.availabilities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

import '../request/availability_request.dart';

part 'events_list.g.dart';

//done this file

@JsonSerializable()
class EventListResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  EventListResponse({this.code, this.message, this.data, this.errors});

  EventListResponse.fromJson(Map<String, dynamic> json) {
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
  List<Events>? events;

  Data({this.events});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  String? title;
  String? description;
  bool? hasImage;
  String? image;

  Events({this.title, this.description, this.hasImage, this.image});

  Events.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    hasImage = json['has_image'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['has_image'] = this.hasImage;
    data['image'] = this.image;
    return data;
  }
}
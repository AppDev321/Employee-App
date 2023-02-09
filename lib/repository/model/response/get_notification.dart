
import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_notification.g.dart';

//done this file

@JsonSerializable()
class GetNotificationResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  GetNotificationResponse({this.code, this.message, this.data, this.errors});

  GetNotificationResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;

    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add( Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
  String? message;
  List<NotificationData>? notifications;

  Data({this.message, this.notifications});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = <NotificationData>[];
      json['notifications'].forEach((v) {
        notifications!.add( NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  int? id;
  int? isRead;
  String? type;
  NotificationObject? notificationData;
  String? createdAt;

  NotificationData(
      {this.id, this.isRead, this.type, this.notificationData, this.createdAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['is_read'];
    type = json['type'];
    notificationData = json['notification_data'] != null
        ?  NotificationObject.fromJson(json['notification_data'])
        : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['is_read'] = this.isRead;
    data['type'] = this.type;
    if (this.notificationData != null) {
      data['notification_data'] = this.notificationData!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class NotificationObject {
  String? body;
  String? type;
  String? title;
  String? activity;

  NotificationObject({this.body, this.type, this.title, this.activity});

  NotificationObject.fromJson(Map<String, dynamic> json) {
    body = json['body'];
    type = json['type'];
    title = json['title'];
    activity = json['activity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['body'] = this.body;
    data['type'] = this.type;
    data['title'] = this.title;
    data['activity'] = this.activity;
    return data;
  }
}
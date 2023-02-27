import 'package:hnh_flutter/repository/model/response/get_shift_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_version_reponse.g.dart';
@JsonSerializable()
class AppVersionResponse {
  int? code;
  String? message;
  Data? data;
  List<Errors>? errors;

  AppVersionResponse({this.code, this.message, this.data, this.errors});

  AppVersionResponse.fromJson(Map<String, dynamic> json) {
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
  List<AppData>? appData;

  Data({this.appData});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['app_data'] != null) {
      appData = <AppData>[];
      json['app_data'].forEach((v) {
        appData!.add(new AppData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appData != null) {
      data['app_data'] = this.appData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppData {
  int? id;
  String? name;
  Null? appName;
  Null? version;
  Null? downloadUrl;
  Null? downloadUrlType;
  int? isEnabled;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  AppData(
      {this.id,
        this.name,
        this.appName,
        this.version,
        this.downloadUrl,
        this.downloadUrlType,
        this.isEnabled,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  AppData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    appName = json['app_name'];
    version = json['version'];
    downloadUrl = json['download_url'];
    downloadUrlType = json['download_url_type'];
    isEnabled = json['is_enabled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['app_name'] = this.appName;
    data['version'] = this.version;
    data['download_url'] = this.downloadUrl;
    data['download_url_type'] = this.downloadUrlType;
    data['is_enabled'] = this.isEnabled;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
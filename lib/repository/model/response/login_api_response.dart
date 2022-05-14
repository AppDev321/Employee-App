import 'package:hnh_flutter/repository/model/response/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'login_api_response.g.dart';

//done this file

@JsonSerializable()
class LoginApiResponse {



  @JsonKey(name: 'token')
  String? token;

  LoginApiResponse({this.token});

  LoginApiResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }


}

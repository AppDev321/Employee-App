import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  String? email;
  String? token;
  String? password;

  ResetPasswordRequest({this.email,this.token,this.password});

  ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['token'] = this.token;
    data['password'] = this.password;
    return data;
  }
}
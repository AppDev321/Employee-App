import 'package:json_annotation/json_annotation.dart';

part 'verify_email_code_request.g.dart';

@JsonSerializable()
class VerifyEmailCodeRequest {
  String? email;
  String? token;

  VerifyEmailCodeRequest({this.email,this.token});

  VerifyEmailCodeRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['token'] = this.token;
    return data;
  }
}
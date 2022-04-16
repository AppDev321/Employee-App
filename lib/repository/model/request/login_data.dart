import 'package:json_annotation/json_annotation.dart';
part 'login_data.g.dart';

@JsonSerializable()
class LoginRequestBody {
  String? email;
  String? password;

  LoginRequestBody({this.email, this.password}); // now create converter

  factory LoginRequestBody.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestBodyToJson(this);
}

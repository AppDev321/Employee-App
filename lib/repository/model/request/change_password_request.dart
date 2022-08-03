import 'package:json_annotation/json_annotation.dart';

part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  String? currentPassword;
  String? newPassword;
  String? newConfirmPassword;

  ChangePasswordRequest(
      {this.currentPassword, this.newPassword, this.newConfirmPassword});

  ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
    newConfirmPassword = json['new_confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_password'] = this.currentPassword;
    data['new_password'] = this.newPassword;
    data['new_confirm_password'] = this.newConfirmPassword;
    return data;
  }
}
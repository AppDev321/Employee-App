// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailCodeRequest _$VerifyEmailCodeRequestFromJson(
        Map<String, dynamic> json) =>
    VerifyEmailCodeRequest(
      email: json['email'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$VerifyEmailCodeRequestToJson(
        VerifyEmailCodeRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'token': instance.token,
    };

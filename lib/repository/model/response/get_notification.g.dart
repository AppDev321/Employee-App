// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetNotificationResponse _$GetNotificationResponseFromJson(
        Map<String, dynamic> json) =>
    GetNotificationResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => Errors.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetNotificationResponseToJson(
        GetNotificationResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

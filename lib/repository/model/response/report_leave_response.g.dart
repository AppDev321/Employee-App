// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_leave_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveReportResponse _$LeaveReportResponseFromJson(Map<String, dynamic> json) =>
    LeaveReportResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => Errors.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LeaveReportResponseToJson(
        LeaveReportResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

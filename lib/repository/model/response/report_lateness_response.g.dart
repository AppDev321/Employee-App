// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_lateness_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatenessReportResponse _$LatenessReportResponseFromJson(
    Map<String, dynamic> json) {
  return LatenessReportResponse(
    code: json['code'] as int?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : LatenessData.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => Errors.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$LatenessReportResponseToJson(
        LatenessReportResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

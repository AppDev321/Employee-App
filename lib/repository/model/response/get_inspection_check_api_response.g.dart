// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_inspection_check_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetInspectionCheckResponse _$GetInspectionCheckResponseFromJson(
    Map<String, dynamic> json) {
  return GetInspectionCheckResponse(
    code: json['code'] as int?,
    message: json['message'] as String?,
    data: json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
    errors: (json['errors'] as List<dynamic>?)
        ?.map((e) => Errors.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GetInspectionCheckResponseToJson(
        GetInspectionCheckResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    vehicle: json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
    totalCount: json['totalCount'] as int?,
    inspection: json['inspection'] == null
        ? null
        : Inspection.fromJson(json['inspection'] as Map<String, dynamic>),
    options: (json['options'] as List<dynamic>?)
        ?.map((e) => CheckOptions.fromJson(e as Map<String, dynamic>))
        .toList(),
    checks: (json['checks'] as List<dynamic>?)
        ?.map((e) => Checks.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'vehicle': instance.vehicle,
      'totalCount': instance.totalCount,
      'inspection': instance.inspection,
      'options': instance.options,
      'checks': instance.checks,
    };

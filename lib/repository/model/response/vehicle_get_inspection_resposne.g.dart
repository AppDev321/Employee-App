// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_get_inspection_resposne.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleGetInspectionResponse _$VehicleGetInspectionResponseFromJson(
    Map<String, dynamic> json) {
  return VehicleGetInspectionResponse(
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

Map<String, dynamic> _$VehicleGetInspectionResponseToJson(
        VehicleGetInspectionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
      'errors': instance.errors,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvertimeRequest _$OvertimeRequestFromJson(Map<String, dynamic> json) {
  return OvertimeRequest(
    date: json['date'] as String?,
    hour: json['hour'] as String?,
    reason: json['reason'] as String?,
  );
}

Map<String, dynamic> _$OvertimeRequestToJson(OvertimeRequest instance) =>
    <String, dynamic>{
      'date': instance.date,
      'hour': instance.hour,
      'reason': instance.reason,
    };

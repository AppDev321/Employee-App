// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_inspection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveInspectionCheckRequest _$SaveInspectionCheckRequestFromJson(
    Map<String, dynamic> json) {
  return SaveInspectionCheckRequest(
    checks: (json['checks'] as List<dynamic>?)
        ?.map((e) => SolvedChecked.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SaveInspectionCheckRequestToJson(
        SaveInspectionCheckRequest instance) =>
    <String, dynamic>{
      'checks': instance.checks,
    };

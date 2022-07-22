// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_inspection_post_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostInspectionData _$PostInspectionDataFromJson(Map<String, dynamic> json) {
  return PostInspectionData(
    inspectionId: json['inspectionId'] as int?,
    checks: (json['checks'] as List<dynamic>?)
        ?.map((e) => Checks.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$PostInspectionDataToJson(PostInspectionData instance) =>
    <String, dynamic>{
      'inspectionId': instance.inspectionId,
      'checks': instance.checks,
    };

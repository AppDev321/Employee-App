// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_inspection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveInspectionCheckRequest _$SaveInspectionCheckRequestFromJson(
    Map<String, dynamic> json) {
  return SaveInspectionCheckRequest(
    vehicleInspectionId: json['vehicleInspectionId'] as String?,
    checkNo: json['checkNo'] as String?,
    name: json['name'] as String?,
    type: json['type'] as String?,
    code: json['code'] as String?,
    comment: json['comment'] as String?,
  );
}

Map<String, dynamic> _$SaveInspectionCheckRequestToJson(
        SaveInspectionCheckRequest instance) =>
    <String, dynamic>{
      'vehicleInspectionId': instance.vehicleInspectionId,
      'checkNo': instance.checkNo,
      'name': instance.name,
      'type': instance.type,
      'code': instance.code,
      'comment': instance.comment,
    };

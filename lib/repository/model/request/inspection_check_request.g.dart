// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_check_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckInspectionRequest _$CheckInspectionRequestFromJson(
        Map<String, dynamic> json) =>
    CheckInspectionRequest(
      vehicleInspectionId: json['vehicleInspectionId'] as String?,
      checkNo: json['checkNo'] as int?,
    );

Map<String, dynamic> _$CheckInspectionRequestToJson(
        CheckInspectionRequest instance) =>
    <String, dynamic>{
      'vehicleInspectionId': instance.vehicleInspectionId,
      'checkNo': instance.checkNo,
    };

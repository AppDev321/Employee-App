// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_inspection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateInspectionRequest _$CreateInspectionRequestFromJson(
    Map<String, dynamic> json) {
  return CreateInspectionRequest(
    vehicleId: json['vehicleId'] as String?,
    type: json['type'] as String?,
    date: json['date'] as String?,
    odometerReading: json['odometerReading'] as String?,
  );
}

Map<String, dynamic> _$CreateInspectionRequestToJson(
        CreateInspectionRequest instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'type': instance.type,
      'date': instance.date,
      'odometerReading': instance.odometerReading,
    };

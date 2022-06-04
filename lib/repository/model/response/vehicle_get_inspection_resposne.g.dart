// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_get_inspection_resposne.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleGetInspectionResponse _$VehicleGetInspectionResponseFromJson(
    Map<String, dynamic> json) {
  return VehicleGetInspectionResponse(
    vehicle: json['vehicle'] == null
        ? null
        : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VehicleGetInspectionResponseToJson(
        VehicleGetInspectionResponse instance) =>
    <String, dynamic>{
      'vehicle': instance.vehicle,
    };

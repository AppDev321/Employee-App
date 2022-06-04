// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetVehicleListResponse _$GetVehicleListResponseFromJson(
    Map<String, dynamic> json) {
  return GetVehicleListResponse(
    vehicles: (json['vehicles'] as List<dynamic>?)
        ?.map((e) => Vehicles.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GetVehicleListResponseToJson(
        GetVehicleListResponse instance) =>
    <String, dynamic>{
      'vehicles': instance.vehicles,
    };

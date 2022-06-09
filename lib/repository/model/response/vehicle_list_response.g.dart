// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    vehicles: (json['vehicles'] as List<dynamic>?)
        ?.map((e) => Vehicles.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'vehicles': instance.vehicles,
    };

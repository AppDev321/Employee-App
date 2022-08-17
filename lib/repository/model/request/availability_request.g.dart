// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailabilityRequest _$AvailabilityRequestFromJson(Map<String, dynamic> json) {
  return AvailabilityRequest(
    startDate: json['startDate'] as String?,
    endDate: json['endDate'] as String?,
    title: json['title'] as String?,
    timeSlot: (json['timeSlot'] as List<dynamic>?)
        ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$AvailabilityRequestToJson(
        AvailabilityRequest instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'title': instance.title,
      'timeSlot': instance.timeSlot,
    };

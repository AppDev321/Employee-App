// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_shift_history_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimShiftHistoryRequest _$ClaimShiftHistoryRequestFromJson(
    Map<String, dynamic> json) {
  return ClaimShiftHistoryRequest(
    start_date: json['start_date'] as String?,
    end_date: json['end_date'] as String?,
  );
}

Map<String, dynamic> _$ClaimShiftHistoryRequestToJson(
        ClaimShiftHistoryRequest instance) =>
    <String, dynamic>{
      'start_date': instance.start_date,
      'end_date': instance.end_date,
    };

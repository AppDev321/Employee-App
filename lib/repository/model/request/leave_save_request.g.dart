// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequest _$LeaveRequestFromJson(Map<String, dynamic> json) => LeaveRequest(
      dateFrom: json['dateFrom'] as String?,
      dateTo: json['dateTo'] as String?,
      subject: json['subject'] as String?,
      description: json['description'] as String?,
      leaveType: json['leaveType'] as String?,
    );

Map<String, dynamic> _$LeaveRequestToJson(LeaveRequest instance) =>
    <String, dynamic>{
      'dateFrom': instance.dateFrom,
      'dateTo': instance.dateTo,
      'subject': instance.subject,
      'description': instance.description,
      'leaveType': instance.leaveType,
    };

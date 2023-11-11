// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_garbage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleGarbage _$ScheduleGarbageFromJson(Map<String, dynamic> json) =>
    ScheduleGarbage(
      id: json['id'] as int?,
      scheduleId: json['scheduleId'] as int?,
      garbageId: json['garbageId'] as int?,
    );

Map<String, dynamic> _$ScheduleGarbageToJson(ScheduleGarbage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'garbageId': instance.garbageId,
    };

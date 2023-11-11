// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as int?,
      pickupDate: json['pickupDate'] == null
          ? null
          : DateTime.parse(json['pickupDate'] as String),
      status: $enumDecodeNullable(_$PickupStatusEnumMap, json['status']),
      vehicleId: json['vehicleId'] as int?,
      vehicle: json['vehicle'] == null
          ? null
          : Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      scheduleDrivers: (json['scheduleDrivers'] as List<dynamic>?)
          ?.map((e) => ScheduleDriver.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduleGarbages: (json['scheduleGarbages'] as List<dynamic>?)
          ?.map((e) => ScheduleGarbage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'pickupDate': instance.pickupDate?.toIso8601String(),
      'status': _$PickupStatusEnumMap[instance.status],
      'vehicleId': instance.vehicleId,
      'vehicle': instance.vehicle,
      'scheduleDrivers': instance.scheduleDrivers,
      'scheduleGarbages': instance.scheduleGarbages,
    };

const _$PickupStatusEnumMap = {
  PickupStatus.completed: 'Completed',
  PickupStatus.pending: 'Pending',
  PickupStatus.cancelled: 'Cancelled',
};

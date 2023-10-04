// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      user: json['user'] == null
          ? null
          : UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      serviceId: json['serviceId'] as int?,
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
      reservationStatus: $enumDecodeNullable(
          _$ReservationStatusEnumMap, json['reservationStatus']),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'serviceId': instance.serviceId,
      'service': instance.service,
      'reservationStatus':
          _$ReservationStatusEnumMap[instance.reservationStatus],
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'price': instance.price,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.inProgress: 'inProgress',
  ReservationStatus.done: 'done',
};

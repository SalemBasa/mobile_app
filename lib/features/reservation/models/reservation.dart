import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/user/models/user.dart';
import 'package:trash_track_mobile/features/services/models/service.dart';

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? id;
  int? userId;
  UserEntity? user;
  int? serviceId;
  Service? service;
  ReservationStatus? reservationStatus; // Use the GarbageType enum here
  double? latitude; // Use double for latitude and longitude
  double? longitude;
  double? price;

  Reservation({
    this.id,
    this.userId,
    this.user,
    this.serviceId,
    this.service,
    this.reservationStatus,
    this.latitude,
    this.longitude,
    this.price
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}

enum ReservationStatus {
  inProgress,
  done
}

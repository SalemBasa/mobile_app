// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
      id: json['id'] as int?,
      color: json['color'] as String?,
      notes: json['notes'] as String?,
      licensePlateNumber: json['licensePlateNumber'] as String?,
      manufactureYear: json['manufactureYear'] as int?,
      capacity: json['capacity'] as int?,
      vehicleModelId: json['vehicleModelId'] as int?,
      vehicleModel: json['vehicleModel'] == null
          ? null
          : VehicleModel.fromJson(json['vehicleModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'notes': instance.notes,
      'licensePlateNumber': instance.licensePlateNumber,
      'manufactureYear': instance.manufactureYear,
      'capacity': instance.capacity,
      'vehicleModelId': instance.vehicleModelId,
      'vehicleModel': instance.vehicleModel,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      vehicleType:
          $enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicleType']),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType],
    };

const _$VehicleTypeEnumMap = {
  VehicleType.truck: 'Truck',
  VehicleType.garbageTruck: 'GarbageTruck',
};

import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  int? id;
  String? name;
  VehicleType? vehicleType;

  VehicleModel({
    this.id,
    this.name,
    this.vehicleType,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}

enum VehicleType {
  truck,
  garbageTruck
}
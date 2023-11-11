import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/vehicles/models/vehicle_model.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Vehicle {
  int? id;
  String? color;
  String? notes;
  String? licensePlateNumber;
  int? manufactureYear;
  int? capacity;
  int? vehicleModelId;
  VehicleModel? vehicleModel;

  Vehicle({
    this.id,
    this.color,
    this.notes,
    this.licensePlateNumber,
    this.manufactureYear,
    this.capacity,
    this.vehicleModelId, 
    this.vehicleModel,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);
}

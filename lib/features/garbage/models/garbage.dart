import 'package:json_annotation/json_annotation.dart';

part 'garbage.g.dart';

@JsonSerializable()
class Garbage {
  int? id;
  String? description;
  String? address;
  GarbageType? garbageType; // Use the GarbageType enum here
  double? latitude; // Use double for latitude and longitude
  double? longitude;

  Garbage({
    this.id,
    this.description,
    this.address,
    this.garbageType,
    this.latitude,
    this.longitude,
  });

  factory Garbage.fromJson(Map<String, dynamic> json) =>
      _$GarbageFromJson(json);

  Map<String, dynamic> toJson() => _$GarbageToJson(this);
}

enum GarbageType {
  plastic,
  glass,
  metal,
  organic
}

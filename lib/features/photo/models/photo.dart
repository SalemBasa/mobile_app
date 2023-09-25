import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/garbage/models/garbage.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  String? data; 

  Photo({this.data});

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

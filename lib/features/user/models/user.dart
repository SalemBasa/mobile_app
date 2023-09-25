import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/country/models/country.dart';
import 'package:trash_track_mobile/features/photo/models/photo.dart';

part 'user.g.dart';

@JsonSerializable()
class UserEntity {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? biography;
  DateTime? birthDate;
  Gender? gender; 
  int? genderId; 
  int? countryId;
  Country? country;
  int? roleId;
  Role? role;
  int? profilePhotoId;
  Photo? profilePhoto;
  bool? isActive;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.biography,
    this.birthDate,
    this.gender,
    this.genderId,
    this.country,
    this.countryId,
    this.role,
    this.roleId,
    this.profilePhoto,
    this.profilePhotoId,
    this.isActive,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}

enum Gender {
  male,
  female,
}

enum Role {
  administrator,
  user,
  driver
}
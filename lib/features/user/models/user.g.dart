// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) => UserEntity(
      id: json['id'] as int?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      biography: json['biography'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      genderId: json['genderId'] as int?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
      countryId: json['countryId'] as int?,
      role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
      roleId: json['roleId'] as int?,
      profilePhoto: json['profilePhoto'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'biography': instance.biography,
      'birthDate': instance.birthDate?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'genderId': instance.genderId,
      'countryId': instance.countryId,
      'country': instance.country,
      'roleId': instance.roleId,
      'role': _$RoleEnumMap[instance.role],
      'profilePhoto': instance.profilePhoto,
      'isActive': instance.isActive,
    };

const _$GenderEnumMap = {
  Gender.male: 'Male',
  Gender.female: 'Female',
};

const _$RoleEnumMap = {
  Role.administrator: 'Administrator',
  Role.user: 'User',
  Role.driver: 'Driver',
};

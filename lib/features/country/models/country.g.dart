// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      name: json['name'] as String?,
      abbreviation: json['abbreviation'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'isActive': instance.isActive,
    };

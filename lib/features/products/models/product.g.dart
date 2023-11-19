// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..code = json['code'] as String?
  ..photo = json['photo'] as String?
  ..price = (json['price'] as num?)?.toDouble()
  ..type = $enumDecodeNullable(_$ProductTypeEnumMap, json['type']);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'photo': instance.photo,
      'price': instance.price,
      'type': _$ProductTypeEnumMap[instance.type],
    };

const _$ProductTypeEnumMap = {
  ProductType.trashBin: 'TrashBin',
  ProductType.trashBag: 'TrashBag',
  ProductType.protectiveGear: 'ProtectiveGear',
};

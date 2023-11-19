// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order()
  ..id = json['id'] as int?
  ..orderNumber = json['orderNumber'] as String?
  ..orderDate = json['orderDate'] == null
      ? null
      : DateTime.parse(json['orderDate'] as String)
  ..total = (json['total'] as num?)?.toDouble()
  ..isCanceled = json['isCanceled'] as bool?
  ..userId = json['userId'] as int?
  ..user = json['user'] == null
      ? null
      : UserEntity.fromJson(json['user'] as Map<String, dynamic>)
  ..orderDetails = (json['orderDetails'] as List<dynamic>?)
      ?.map((e) => OrderDetails.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'orderDate': instance.orderDate?.toIso8601String(),
      'total': instance.total,
      'isCanceled': instance.isCanceled,
      'userId': instance.userId,
      'user': instance.user,
      'orderDetails': instance.orderDetails,
    };

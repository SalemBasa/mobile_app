// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails()
  ..id = json['id'] as int?
  ..orderId = json['orderId'] as int?
  ..quantity = json['quantity'] as int?
  ..productId = json['productId'] as int?
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>);

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'quantity': instance.quantity,
      'productId': instance.productId,
      'product': instance.product,
    };

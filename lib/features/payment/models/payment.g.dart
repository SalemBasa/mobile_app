// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment()
  ..id = json['id'] as int?
  ..amount = (json['amount'] as num?)?.toDouble()
  ..dateOfTransaction = json['dateOfTransaction'] == null
      ? null
      : DateTime.parse(json['dateOfTransaction'] as String)
  ..numberOfTransaction = json['numberOfTransaction'] as String?
  ..userId = json['userId'] as int?;

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'dateOfTransaction': instance.dateOfTransaction?.toIso8601String(),
      'numberOfTransaction': instance.numberOfTransaction,
      'userId': instance.userId,
    };

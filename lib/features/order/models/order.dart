import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/order_details/models/order_detail.dart';
import 'package:trash_track_mobile/features/user/models/user.dart';

part 'order.g.dart';

@JsonSerializable()
class Order{
  int? id;
  String? orderNumber;
  DateTime? orderDate;
  double? total;
  bool? isCanceled;
  int? userId;
  UserEntity? user;
  List<OrderDetails>? orderDetails;
  

  Order();

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

    Map<String, dynamic> toJson() => _$OrderToJson(this);
}
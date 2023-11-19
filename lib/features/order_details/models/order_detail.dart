import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/products/models/product.dart';

part 'order_detail.g.dart';

@JsonSerializable()
class OrderDetails{
  int? id;
  int? orderId;
  int? quantity;
  int? productId;
  Product? product;

  OrderDetails();

  factory OrderDetails.fromJson(Map<String, dynamic> json) => _$OrderDetailsFromJson(json);

    Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}
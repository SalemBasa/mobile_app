import 'package:trash_track_mobile/features/order/models/order.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class OrderService extends BaseService<Order> {
  OrderService() : super("Orders"); 

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }
}

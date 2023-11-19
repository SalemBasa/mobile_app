import 'package:trash_track_mobile/features/payment/models/payment.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class PaymentService extends BaseService<Payment> {
  PaymentService() : super("Payments"); 

  @override
  Payment fromJson(data) {
    return Payment.fromJson(data);
  }
}

import 'package:http/http.dart' as http;
import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
import 'package:trash_track_mobile/features/reservation/models/reservation.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class ReservationService extends BaseService<Reservation> {
  ReservationService() : super("Reservation"); // "users" is the endpoint for your user API

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }
}

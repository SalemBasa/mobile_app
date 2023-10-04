import 'package:http/http.dart' as http;
import 'package:trash_track_mobile/features/services/models/service.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class ServicesService extends BaseService<Service> {
  ServicesService() : super("Service"); // "users" is the endpoint for your user API

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }
}

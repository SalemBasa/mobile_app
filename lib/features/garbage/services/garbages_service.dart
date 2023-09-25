import 'package:http/http.dart' as http;
import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class GarbageService extends BaseService<Garbage> {
  GarbageService() : super("Garbages"); // "users" is the endpoint for your user API

  @override
  Garbage fromJson(data) {
    return Garbage.fromJson(data);
  }
}

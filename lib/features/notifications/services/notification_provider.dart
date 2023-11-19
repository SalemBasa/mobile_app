import 'dart:convert';

import 'package:http/http.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

import '../models/notification.dart';

class NotificationProvider extends BaseService<Notif> {
  String? _mainBaseUrl;
  final String _mainEndpoint = "api/Notification/SendNotification";

  NotificationProvider() : super('Notifications') {
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl",
        defaultValue: "http://10.0.2.2:7138/");
  }

  @override
  Notif fromJson(data) {
    return Notif.fromJson(data);
  }

  Future<void> readNotfication(int notifId) async {
    var url = "${BaseService.baseUrl}$endpoint/NotificationRabbit/$notifId";

    var uri = Uri.parse(url);

    var headers = createHeaders();

    Response response = await put(uri, headers: headers, body: null);

    if (isValidResponse(response)) {
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<dynamic> sendRabbitNotification(dynamic object) async {
    var url = "$_mainBaseUrl$_mainEndpoint";

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var jsonRequest = jsonEncode(object);

    Response response = await post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("Unknown error");
    }
  }
}

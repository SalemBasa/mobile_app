import 'package:http/http.dart' as http;
import 'package:trash_track_mobile/features/schedules/models/schedule.dart';
import 'dart:convert';

import 'package:trash_track_mobile/shared/services/base_service.dart';

class ScheduleService extends BaseService<Schedule> {
  ScheduleService() : super("Schedules"); 

  @override
  Schedule fromJson(data) {
    return Schedule.fromJson(data);
  }

  Future<List<int>> getDriverIdsByScheduleId(int scheduleId) async {
    final url = Uri.parse('http://localhost:5057/api/ScheduleDrivers/BySchedule?scheduleId=$scheduleId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        
        final List<int> driverIds = jsonData.cast<int>();

        return driverIds;
      } else {
        throw Exception('Failed to load driver IDs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

import 'package:trash_track_mobile/features/report/models/report.dart';
import 'package:trash_track_mobile/shared/services/base_service.dart';

class ReportService extends BaseService<Report> {
  ReportService() : super("Reports"); // "users" is the endpoint for your user API

  @override
  Report fromJson(data) {
    return Report.fromJson(data);
  }
}
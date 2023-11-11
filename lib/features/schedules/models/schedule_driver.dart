import 'package:json_annotation/json_annotation.dart';

part 'schedule_driver.g.dart';

@JsonSerializable()
class ScheduleDriver {
  int? id;
  int? scheduleId;
  int? driverId;


  ScheduleDriver({this.id, this.scheduleId, this.driverId});

  factory ScheduleDriver.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDriverFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleDriverToJson(this);
}
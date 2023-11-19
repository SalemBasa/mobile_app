import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/user/models/user.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notif {
  //because there is pedifiend class nothification in flutter
  int? id;
  String? title;
  String? content;
  bool? isRead;
  int? userId;
  UserEntity? user;
  DateTime? createdAt;

  Notif(this.id, this.title, this.content, this.isRead, this.userId, this.user, this.createdAt);

  factory Notif.fromJson(Map<String, dynamic> json) => _$NotifFromJson(json);

  Map<String, dynamic> toJson() => _$NotifToJson(this);
}
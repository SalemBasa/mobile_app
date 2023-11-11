// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['id'] as int?,
      note: json['note'] as String?,
      reportState:
          $enumDecodeNullable(_$ReportStateEnumMap, json['reportState']),
      reportType: $enumDecodeNullable(_$ReportTypeEnumMap, json['reportType']),
      reporterUser: json['reporterUser'] == null
          ? null
          : UserEntity.fromJson(json['reporterUser'] as Map<String, dynamic>),
      reporterUserId: json['reporterUserId'] as int?,
      photo: json['photo'] as String?,
      garbage: json['garbage'] == null
          ? null
          : Garbage.fromJson(json['garbage'] as Map<String, dynamic>),
      garbageId: json['garbageId'] as int?,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'reportState': _$ReportStateEnumMap[instance.reportState],
      'reportType': _$ReportTypeEnumMap[instance.reportType],
      'reporterUser': instance.reporterUser,
      'reporterUserId': instance.reporterUserId,
      'photo': instance.photo,
      'garbage': instance.garbage,
      'garbageId': instance.garbageId,
    };

const _$ReportStateEnumMap = {
  ReportState.waitingForReview: 'waitingForReview',
  ReportState.reviewed: 'reviewed',
};

const _$ReportTypeEnumMap = {
  ReportType.trashOverflow: 'trashOverflow',
  ReportType.littering: 'littering',
  ReportType.garbageBinDamage: 'garbageBinDamage',
  ReportType.graffitiVandalism: 'graffitiVandalism',
};

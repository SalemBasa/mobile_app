import 'package:json_annotation/json_annotation.dart';
import 'package:trash_track_mobile/features/quiz/models/question.dart';

part 'quiz.g.dart';

@JsonSerializable()
class Quiz {
  int? id;
  String? title;
  String? description;
  List<Question>? questions;

  Quiz({this.id, this.title, this.description, this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);

  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
import 'question_model.dart';

class SummaryModel {
  const SummaryModel({
    required this.summary,
    required this.questions,
  });

  final String summary;
  final List<QuestionModel> questions;
}

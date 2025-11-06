import 'dart:math';

import '../models/question_model.dart';
import '../models/summary_model.dart';

class ApiService {
  const ApiService();

  Future<SummaryModel> generateSummaryAndQuestions(String input) async {
    await Future.delayed(const Duration(seconds: 2));

    final summary = _createMockSummary(input);
    final questions = _createMockQuestions(input);

    return SummaryModel(summary: summary, questions: questions);
  }

  String _createMockSummary(String input) {
    if (input.trim().isEmpty) {
      return 'לא נמצא טקסט לעיבוד.';
    }
    final sanitized = input.replaceAll(RegExp(r'\s+'), ' ');
    return sanitized.length <= 280 ? sanitized : '${sanitized.substring(0, 280)}...';
  }

  List<QuestionModel> _createMockQuestions(String input) {
    final seed = input.hashCode;
    final random = Random(seed);

    return List<QuestionModel>.generate(4, (index) {
      final correctIndex = random.nextInt(4);
      return QuestionModel(
        id: 'q$index',
        questionText: 'שאלה ${index + 1}: על מה עוסק החומר שקיבלתם?',
        options: List<String>.generate(4, (optionIndex) {
          if (optionIndex == correctIndex) {
            return 'תשובה נכונה המבוססת על החומר שהוזן.';
          }
          return 'אפשרות חלופית ${optionIndex + 1} לטקסט שנבחר.';
        }),
        correctAnswerIndex: correctIndex,
      );
    });
  }
}

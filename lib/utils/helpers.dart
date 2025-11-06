import 'package:flutter/material.dart';

import '../models/question_model.dart';

void showSnackBar(BuildContext context, String message) {
  if (message.isEmpty) return;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

String formatShortDate(DateTime date) {
  final twoDigits = (int value) => value.toString().padLeft(2, '0');
  return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
}

String truncate(String value, {int maxLength = 120}) {
  if (value.length <= maxLength) {
    return value;
  }
  return '${value.substring(0, maxLength - 1)}…';
}

String formatQuestionsSummary(List<Question> questions) {
  if (questions.isEmpty) {
    return 'No questions generated yet.';
  }

  final buffer = StringBuffer();
  for (var i = 0; i < questions.length; i++) {
    final question = questions[i];
    buffer.writeln('${i + 1}. ${question.text}');
    if (question.answer != null) {
      buffer.writeln('   Answer: ${question.answer}');
    }
  }
  return buffer.toString().trim();
}

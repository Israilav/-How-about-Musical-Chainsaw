import 'dart:math';

import '../models/question_model.dart';
import '../models/summary_model.dart';
import '../utils/constants.dart';

class ApiService {
  ApiService({this.baseUrl = AppConstants.baseUrl});

  final String baseUrl;
  final _random = Random();

  Future<Summary> fetchSummary({required String imagePath}) async {
    await Future<void>.delayed(AppConstants.networkDelay);
    return _mockSummary(imagePath: imagePath);
  }

  Future<List<Question>> fetchSuggestedQuestions({required String summaryId}) async {
    await Future<void>.delayed(
      Duration(milliseconds: AppConstants.networkDelay.inMilliseconds ~/ 2),
    );
    return _mockQuestions(summaryId: summaryId);
  }

  Summary _mockSummary({required String imagePath}) {
    final now = DateTime.now();
    final questions = _mockQuestions(summaryId: imagePath.hashCode.toString());
    return Summary(
      id: 'summary-${now.millisecondsSinceEpoch}',
      title: 'Document Summary',
      description:
          'This is a placeholder summary generated for the captured document at $imagePath. '
          'Replace this logic with a real network call to $baseUrl.',
      questions: questions,
      createdAt: now,
    );
  }

  List<Question> _mockQuestions({required String summaryId}) {
    final sampleQuestions = <String>[
      'What is the main topic discussed in the document?',
      'List two key takeaways mentioned.',
      'How can the findings be applied in practice?',
    ];

    return List<Question>.generate(sampleQuestions.length, (index) {
      final options = <String>[
        'Option A',
        'Option B',
        'Option C',
      ]..shuffle(_random);

      return Question(
        id: '$summaryId-$index',
        text: sampleQuestions[index],
        options: options,
        answer: index.isEven ? options.first : null,
      );
    });
  }
}

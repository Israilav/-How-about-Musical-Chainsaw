import 'question_model.dart';

class Summary {
  const Summary({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final DateTime createdAt;

  bool get hasQuestions => questions.isNotEmpty;

  Summary copyWith({
    String? id,
    String? title,
    String? description,
    List<Question>? questions,
    DateTime? createdAt,
  }) {
    return Summary(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Summary.empty() => Summary(
        id: 'empty',
        title: 'No summary available',
        description: 'Scan a document to view its summary here.',
        questions: const <Question>[],
        createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      );

  factory Summary.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['questions'];
    return Summary(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      questions: rawQuestions is List
          ? rawQuestions
              .map((raw) => Question.fromJson(Map<String, dynamic>.from(raw)))
              .toList()
          : const <Question>[],
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'questions': questions.map((question) => question.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}

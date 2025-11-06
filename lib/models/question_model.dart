class Question {
  const Question({
    required this.id,
    required this.text,
    this.options = const <String>[],
    this.answer,
  });

  final String id;
  final String text;
  final List<String> options;
  final String? answer;

  Question copyWith({
    String? id,
    String? text,
    List<String>? options,
    String? answer,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      options: options ?? this.options,
      answer: answer ?? this.answer,
    );
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    return Question(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      options: rawOptions is List
          ? rawOptions.map((option) => option.toString()).toList()
          : const <String>[],
      answer: json['answer']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        'options': options,
        if (answer != null) 'answer': answer,
      };
}

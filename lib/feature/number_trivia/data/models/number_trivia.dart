import 'package:tdd_practice_flutter/feature/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaResponseModel extends NumberTrivia {
  final String text;
  final int number;

  const NumberTriviaResponseModel({
    required this.text,
    required this.number,
  }) : super(text: text, number: number);

  factory NumberTriviaResponseModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaResponseModel(
      text: json['text'],
      number: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}

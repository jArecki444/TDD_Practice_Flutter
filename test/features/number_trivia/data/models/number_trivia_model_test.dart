import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/data/models/number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testNumberTriviaModel = NumberTriviaResponseModel(
    number: 1,
    text: 'Test Trivia',
  );
  test('Should be a subclass of NumberTrivia entity', () async {
    expect(testNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('trivia'),
      );
      final result = NumberTriviaResponseModel.fromJson(jsonMap);
      expect(result, testNumberTriviaModel);
    });
  });
  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final result = testNumberTriviaModel.toJson();
      final expectedMap = {
        "text": "Test Trivia",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}

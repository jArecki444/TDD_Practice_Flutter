import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_practice_flutter/core/usecases/usecases.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final testNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

  test(
    'should get trivia from the repo',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => Right(testNumberTrivia));

      // act
      final result = await usecase(NoParams());

      //assert
      expect(result, Right(testNumberTrivia));

      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}

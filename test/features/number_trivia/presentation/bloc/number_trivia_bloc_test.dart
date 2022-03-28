import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice_flutter/core/error/failures.dart';
import 'package:tdd_practice_flutter/core/util/input_converter.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([InputConverter, GetConcreteNumberTrivia, GetRandomNumberTrivia])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTriviaUseCase;
  late MockGetRandomNumberTrivia mockGetRandomNumberTriviaUseCase;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTriviaUseCase,
      getRandomNumberTrivia: mockGetRandomNumberTriviaUseCase,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = const NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));

    void setUpMockGetConcreteSuccess() =>
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    // OLD WAY
    // test(
    //   'should emit [Error] when the input is invalid',
    //   () async {
    //     // arrange
    //     when(mockInputConverter.stringToUnsignedInteger(any))
    //         .thenReturn(Left(InvalidInputFailure()));
    //     // assert later
    //     final expected = [
    //       Empty(),
    //       const Error(message: invalidInputFailureMessage),
    //     ];
    //     expectLater(bloc, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid - new way using blocTest',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [const Error(message: invalidInputFailureMessage)],
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTriviaUseCase(any));
        // assert
        verify(mockGetConcreteNumberTriviaUseCase(
            const Params(number: tNumberParsed)));
      },
    );

    // OLD WAY
    // test(
    //   'should emit [Loading, Loaded] when data is gotten successfully',
    //   () async {
    //     // arrange
    //     setUpMockInputConverterSuccess();
    //     when(mockGetConcreteNumberTrivia(any))
    //         .thenAnswer((_) async => const Right(tNumberTrivia));
    //     // assert later
    //     final expected = [
    //       Loading(),
    //       Loaded(trivia: tNumberTrivia),
    //     ];
    //     expectLater(bloc.stream, emitsInOrder(expected));
    //     // act
    //     bloc.add(GetTriviaForConcreteNumber(tNumberString));
    //   },
    // );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Loading(), Loaded(trivia: tNumberTrivia)],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Loading(), Error(message: serverFailureMessage)],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTriviaUseCase(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Loading(), Error(message: cacheFailureMessage)],
    );
  });
}

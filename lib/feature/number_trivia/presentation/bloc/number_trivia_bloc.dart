import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_practice_flutter/core/error/failures.dart';
import 'package:tdd_practice_flutter/core/usecases/usecases.dart';
import 'package:tdd_practice_flutter/core/util/input_converter.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaState get initialState => Empty();

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(
      (event, emit) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        inputEither.fold(
          (failure) {
            //LEFT
            emit(
              const Error(message: invalidInputFailureMessage),
            );
          },
          (integer) async {
            //RIGHT
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(number: integer),
            );
            emit(
              _eitherLoadedOrErrorState(failureOrTrivia),
            );
          },
        );
      },
    );
    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        emit(
          _eitherLoadedOrErrorState(failureOrTrivia),
        );
      },
    );
  }

  NumberTriviaState _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) {
    return failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }
}

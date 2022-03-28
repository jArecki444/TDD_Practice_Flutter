import 'package:dartz/dartz.dart';
import 'package:tdd_practice_flutter/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    int? value = int.tryParse(str);
    return value == null || value.isNegative
        ? Left(InvalidInputFailure())
        : Right(value);

    /// Refactor info:
    /// One rule of thumb for error handling is to never depend on a try-catch if you don't need to,
    /// manually throwing an error that you are immediately catching is a good sign that this is the case.
    /// Instead of using int.parse, use int.tryParse, which returns null if the input isn't a valid integer instead of throwing an error.
    // try {
    //   final integer = int.parse(str);
    //   if (integer < 0) throw const FormatException();
    //   return Right(integer);
    // } on FormatException {
    //   return Left(InvalidInputFailure());
    // }
  }
}

class InvalidInputFailure extends Failure {}

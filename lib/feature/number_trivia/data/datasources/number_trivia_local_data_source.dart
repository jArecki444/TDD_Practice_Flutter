import 'package:tdd_practice_flutter/feature/number_trivia/data/models/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaResponseModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaResponseModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaResponseModel triviaToCache);
}

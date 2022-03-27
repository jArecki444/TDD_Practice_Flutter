import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_practice_flutter/core/error/exceptions.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/data/models/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaResponseModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaResponseModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaResponseModel triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class SharedPrefNumberTriviaLocalDataSource
    implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  SharedPrefNumberTriviaLocalDataSource({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaResponseModel triviaToCache) {
    return sharedPreferences.setString(
      cachedNumberTrivia,
      json.encode(triviaToCache.toJson()),
    );
  }

  @override
  Future<NumberTriviaResponseModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(
          NumberTriviaResponseModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}

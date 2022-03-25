import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice_flutter/core/platform/network_info.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_practice_flutter/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

// @GenerateMocks([], customMocks: [
//   MockSpec<NumberTriviaRemoteDataSource>(as: #MockRemoteDataSource)
// ])
// @GenerateMocks([], customMocks: [
//   MockSpec<NumberTriviaLocalDataSource>(as: #MockLocalDataSource)
// ])
// @GenerateMocks([NetworkInfo])

@GenerateMocks([
  NetworkInfo
], customMocks: [
  MockSpec<NumberTriviaRemoteDataSource>(as: #MockRemoteDataSource),
  MockSpec<NumberTriviaLocalDataSource>(as: #MockLocalDataSource),
])
void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

}

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  serviceLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: serviceLocator(),
      getRandomNumberTrivia: serviceLocator(),
      inputConverter: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Data sources
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => HttpNumberTriviaRemoteDataSource(client: serviceLocator()),
  );

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => SharedPrefNumberTriviaLocalDataSource(sharedPreferences: serviceLocator()),
  );

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}

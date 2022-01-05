import 'package:cleancode/core/network/network_info.dart';
import 'package:cleancode/core/utils/input_converter.dart';
import 'package:cleancode/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:cleancode/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:cleancode/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final inj = GetIt.instance;

Future<void> initDependencies() async {
  _initFeatures();
  _initUseCases();
  _initRepositories();
  _initDataSources();
  _initCore();
  await _initExternal();
}

_initFeatures() {
  //FEATURES
  inj.registerFactory<NumberTriviaBloc>(
    () => NumberTriviaBloc(
      concrete: inj(),
      random: inj(),
      converter: inj(),
    ),
  );
}

_initUseCases() {
  //USECASES
  inj.registerLazySingleton(
    () => GetRandomNumberTriviaUseCase(
      inj(),
    ),
  );
  inj.registerLazySingleton(
    () => GetNumberTriviaUseCase(
      inj(),
    ),
  );
}

_initRepositories() {
  inj.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDatasource: inj(),
      localDatasource: inj(),
      networkInfo: inj(),
    ),
  );
}

_initDataSources() {
  inj.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => RemoteNumberTriviaDataSourceImpl(inj()),
  );
  inj.registerLazySingleton<NumberTriviaLocalDatasource>(
    () => LocalNumberTriviaDataSourceImpl(
      inj(),
    ),
  );
}

_initCore() {
  inj.registerLazySingleton(() => InputConverter());
  inj.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(inj()));
}

_initExternal() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  inj.registerLazySingleton(() => sharedPreferences);
  inj.registerLazySingleton(() => http.Client());
  inj.registerLazySingleton(() => InternetConnectionChecker());
}

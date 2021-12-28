import 'package:cleancode/core/constants/local_data_sources_const.dart';
import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  ///Calls the NumberTrivia SharedPreferences
  ///
  ///Throws a [LocalException] for all error codes
  Future<NumberTriviaModel>? getLastNumberTrivia();

  ///Calls the NumberTrivia SharedPreferences
  ///
  ///Throws a [LocaException] for all error codes
  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaCache);
}

class LocalNumberTriviaDataSourceImpl implements NumberTriviaLocalDatasource {
  SharedPreferences localDataSource;

  LocalNumberTriviaDataSourceImpl(this.localDataSource);

  @override
  Future<void>? cacheNumberTrivia(NumberTriviaModel triviaCache){
    return localDataSource.setString(CACHED_NUMBER_TRIVIA, triviaCache.toJson());
  }

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final String? jsonString = localDataSource.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(jsonString));
    }
    throw LocalException();
  }
}

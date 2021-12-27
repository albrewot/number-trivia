import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  ///Calls the NumberTrivia SharedPreferences
  ///
  ///Throws a [LocalException] for all error codes
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///Calls the NumberTrivia SharedPreferences
  ///
  ///Throws a [LocaException] for all error codes
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaCache);
}

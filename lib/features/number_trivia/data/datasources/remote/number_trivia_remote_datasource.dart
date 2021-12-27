import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  ///Calls the http://numbersapi.com/{number} endpoint
  ///
  ///Throws a [RemoteException] for all error codes
  Future<NumberTriviaModel> getNumberTrivia(int number);

  ///Calls the http://numbersapi.com/{number} endpoint
  ///
  ///Throws a [RemoteException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart';

abstract class NumberTriviaRemoteDatasource {
  ///Calls the http://numbersapi.com/{number} endpoint
  ///
  ///Throws a [RemoteException] for all error codes
  Future<NumberTriviaModel>? getNumberTrivia(int number);

  ///Calls the http://numbersapi.com/{number} endpoint
  ///
  ///Throws a [RemoteException] for all error codes
  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class RemoteNumberTriviaDataSourceImpl implements NumberTriviaRemoteDatasource {
  final Client httpClient;

  RemoteNumberTriviaDataSourceImpl(this.httpClient);

  @override
  Future<NumberTriviaModel>? getNumberTrivia(int number) async =>
      _getTriviaFromUrl("http://numbersapi.com/$number")!;

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() async =>
      _getTriviaFromUrl("http://numbersapi.com/random")!;

  Future<NumberTriviaModel>? _getTriviaFromUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);

      final response = await httpClient.get(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        return NumberTriviaModel.fromJson(response.body);
      } else {
        throw RemoteException();
      }
    } on RemoteException catch (_) {
      throw RemoteException();
    } catch (_) {
      throw RemoteException();
    }
  }
}

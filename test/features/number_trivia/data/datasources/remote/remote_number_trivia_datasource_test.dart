import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  RemoteNumberTriviaDataSourceImpl? remoteNumberTriviaDataSourceImpl;
  MockHttpClient? mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteNumberTriviaDataSourceImpl =
        RemoteNumberTriviaDataSourceImpl(mockHttpClient!);
    registerFallbackValue(Uri.parse("http://numbersapi.com/1"));
  });

  void setUpSuccessHttpResponse() {
    when(() => mockHttpClient!
            .get(any(that: isNotNull), headers: any(named: 'headers')))
        .thenAnswer(
            (_) async => http.Response(fixtureReader("trivia.json"), 200));
  }

  void setUpFailure404() {
    when(() => mockHttpClient!
            .get(any(that: isNotNull), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response("exception", 404));
  }

  group("remoteDataSource NumberTrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixtureReader("trivia.json"));
    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpSuccessHttpResponse();
        // act
        remoteNumberTriviaDataSourceImpl!.getNumberTrivia(tNumber);
        // assert
        verify(
          () => mockHttpClient!.get(
            Uri.parse("http://numbersapi.com/$tNumber"),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
      },
    );

    test(
      'should return number trivia when the response code is 200',
      () async {
        // arrange
        setUpSuccessHttpResponse();
        // act
        final result =
            await remoteNumberTriviaDataSourceImpl!.getNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw a RemoteException when  the response code is different from 200',
      () async {
        // arrange
        setUpFailure404();
        // act
        final call = remoteNumberTriviaDataSourceImpl!.getNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(isA<RemoteException>()));
      },
    );
  });

  group("remoteDataSource RandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixtureReader("trivia.json"));
    test(
      'should perform a GET request on a URL with random being the endpoint and with application/json header',
      () async {
        // arrange
        setUpSuccessHttpResponse();
        // act
        remoteNumberTriviaDataSourceImpl!.getRandomNumberTrivia();
        // assert
        verify(
          () => mockHttpClient!.get(
            Uri.parse("http://numbersapi.com/random"),
            headers: {
              "Content-Type": "application/json",
            },
          ),
        );
      },
    );

    test(
      'should return number trivia when the response code is 200',
      () async {
        // arrange
        setUpSuccessHttpResponse();
        // act
        final result =
            await remoteNumberTriviaDataSourceImpl!.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should throw a RemoteException when  the response code is different from 200',
      () async {
        // arrange
        setUpFailure404();
        // act
        final call = remoteNumberTriviaDataSourceImpl!.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<RemoteException>()));
      },
    );
  });
}

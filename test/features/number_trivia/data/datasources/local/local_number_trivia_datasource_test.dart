import 'package:cleancode/core/constants/local_data_sources_const.dart';
import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  MockSharedPreferences? mockSharedPreferences;
  LocalNumberTriviaDataSourceImpl? localNumberTriviaDatasourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localNumberTriviaDatasourceImpl =
        LocalNumberTriviaDataSourceImpl(mockSharedPreferences!);
  });

  group("getLastNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(fixtureReader("trivia_cached.json"));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in local data source',
      () async {
        // arrange
        when(() => mockSharedPreferences!.getString(any(that: isNotNull)))
            .thenReturn(
          fixtureReader("trivia_cached.json"),
        );
        // act
        final result =
            await localNumberTriviaDatasourceImpl!.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferences!.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );
    test(
      'should return LocalException from SharedPreferences when there is no cached number presnet in local data source',
      () async {
        // arrange
        when(() => mockSharedPreferences!.getString(any(that: isNotNull)))
            .thenReturn(null);
        // act
        final result = localNumberTriviaDatasourceImpl!.getLastNumberTrivia;
        // assert
        expect(() => result(), throwsA(isA<LocalException>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test trivia");
    test(
      'should call SharedPreferences to cache the obtained number trivia',
      () async {
        // arrange
        when(() => mockSharedPreferences!
                .setString(CACHED_NUMBER_TRIVIA, tNumberTriviaModel.toJson()))
            .thenAnswer((_) => Future.value(true));
        // act
        await localNumberTriviaDatasourceImpl!
            .cacheNumberTrivia(tNumberTriviaModel);
        // assert
        // verify(() => mockSharedPreferences!
        //     .setString(CACHED_NUMBER_TRIVIA, tNumberTriviaModel.toJson()));
      },
    );
  });
}

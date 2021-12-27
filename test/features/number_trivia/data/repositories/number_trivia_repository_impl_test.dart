import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/network/network_info.dart';
import 'package:cleancode/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:cleancode/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleancode/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepository? repository;
  MockRemoteDataSource? mockRemoteDataSource;
  MockLocalDataSource? mockLocalDataSource;
  MockNetworkInfo? mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: mockRemoteDataSource!,
      localDatasource: mockLocalDataSource!,
      networkInfo: mockNetworkInfo!,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group("getRandomNumberTrivia", () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "text test");
    const tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      // arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource!.getRandomNumberTrivia(),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => tNumberTrivia);
      // act
      await repository!.getRandomNumberTrivia();
      // assert
      // expect(result., tNumberTrivia);
      verifyInOrder([
        () => mockNetworkInfo!.isConnected,
        // () => mockRemoteDataSource!.getNumberTrivia(tNumber),
      ]);
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to the remote server is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => tNumberTrivia);
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyInOrder([
            () => mockRemoteDataSource!.getRandomNumberTrivia(),
            () => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel),
          ]);
          expect(result, const Right(tNumberTrivia));
        },
      );
      test(
        'should throw remote failure when the call to the remote server is unsuccessful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getRandomNumberTrivia(),
          ).thenThrow(RemoteException());
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verify(() => mockRemoteDataSource!.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(RemoteFailure("remote failure")));
        },
      );
      test(
        'should cache the remote data when the call to the remote server is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => tNumberTrivia);
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          expect(result, const Right(tNumberTrivia));
          verifyInOrder([
            () => mockRemoteDataSource!.getRandomNumberTrivia(),
            () => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel),
          ]);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, const Right(tNumberTriviaModel));
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
        },
      );
      test(
        'should throw local exception when the cached data is not present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(LocalException());
          // act
          final result = await repository!.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Left(LocalFailure("local failure")));
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
        },
      );
    });
  });

  group("getNumberTrivia", () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "text test");
    const tNumberTrivia = tNumberTriviaModel;
    test('should check if device is online', () async {
      // arrange
      when(() => mockNetworkInfo!.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDataSource!.getNumberTrivia(any(that: isNotNull)),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => tNumberTrivia);
      // act
      await repository!.getNumberTrivia(tNumber);
      // assert
      // expect(result., tNumberTrivia);
      verifyInOrder([
        () => mockNetworkInfo!.isConnected,
        // () => mockRemoteDataSource!.getNumberTrivia(tNumber),
      ]);
    });

    runTestOnline(() {
      test(
        'should return remote data when the call to the remote server is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getNumberTrivia(any(that: isNotNull)),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => tNumberTrivia);
          // act
          final result = await repository!.getNumberTrivia(tNumber);
          // assert
          verifyInOrder([
            () => mockRemoteDataSource!.getNumberTrivia(tNumber),
            () => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel),
          ]);
          expect(result, const Right(tNumberTrivia));
        },
      );
      test(
        'should throw remote failure when the call to the remote server is unsuccessful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getNumberTrivia(any(that: isNotNull)),
          ).thenThrow(RemoteException());
          // act
          final result = await repository!.getNumberTrivia(tNumber);
          // assert
          verify(() => mockRemoteDataSource!.getNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(RemoteFailure("remote failure")));
        },
      );
      test(
        'should cache the remote data when the call to the remote server is successful',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource!.getNumberTrivia(any(that: isNotNull)),
          ).thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async => tNumberTrivia);
          // act
          final result = await repository!.getNumberTrivia(tNumber);
          // assert
          expect(result, const Right(tNumberTrivia));
          verifyInOrder([
            () => mockRemoteDataSource!.getNumberTrivia(tNumber),
            () => mockLocalDataSource!.cacheNumberTrivia(tNumberTriviaModel),
          ]);
        },
      );
    });

    runTestOffline(() {
      test(
        'should return cached data when the cached data is present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository!.getNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, const Right(tNumberTriviaModel));
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
        },
      );
      test(
        'should throw local exception when the cached data is not present',
        () async {
          // arrange
          when(() => mockLocalDataSource!.getLastNumberTrivia())
              .thenThrow(LocalException());
          // act
          final result = await repository!.getNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, Left(LocalFailure("local failure")));
          verify(() => mockLocalDataSource!.getLastNumberTrivia());
        },
      );
    });
  });
}

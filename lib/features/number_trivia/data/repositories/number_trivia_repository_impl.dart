import 'package:cleancode/core/error/exceptions/exceptions.dart';
import 'package:cleancode/core/network/network_info.dart';
import 'package:cleancode/features/number_trivia/data/datasources/local/number_trivia_local_datasource.dart';
import 'package:cleancode/features/number_trivia/data/datasources/remote/number_trivia_remote_datasource.dart';
import 'package:cleancode/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef _GetNumberOrRandom = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  Future<Either<Failure, NumberTrivia>>? _getTrivia(
      _GetNumberOrRandom getTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await getTrivia();
        localDatasource.cacheNumberTrivia(result);
        return Right(result);
      } on RemoteException catch (_) {
        return Left(RemoteFailure("remote failure"));
      }
    } else {
      try {
        final localTrivia = await localDatasource.getLastNumberTrivia();
        return Right(localTrivia!);
      } on LocalException catch (_) {
        return Left(LocalFailure("local failure"));
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getNumberTrivia(int number) async {
    return await _getTrivia(() {
      return remoteDatasource.getNumberTrivia(number)!;
    })!;
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDatasource.getRandomNumberTrivia()!;
    })!;
  }
}

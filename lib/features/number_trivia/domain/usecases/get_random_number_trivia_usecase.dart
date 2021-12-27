import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/models/usecase.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTriviaUseCase
    implements UseCase<Either<Failure, NumberTrivia>, void> {
  final NumberTriviaRepository _numberTriviaRepository;
  GetRandomNumberTriviaUseCase(this._numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call([void params]) async {
    return await _numberTriviaRepository.getRandomNumberTrivia()!;
  }
}

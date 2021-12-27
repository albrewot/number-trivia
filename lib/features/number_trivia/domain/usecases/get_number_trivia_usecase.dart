import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/models/usecase.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetNumberTriviaUseCase
    implements UseCase<Either<Failure, NumberTrivia>, GetNumberTriviaParams> {
  final NumberTriviaRepository _numberTriviaRepository;
  GetNumberTriviaUseCase(this._numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>>? call(GetNumberTriviaParams? params) async {
    return await _numberTriviaRepository.getNumberTrivia(params!.number)!;
  }
}

class GetNumberTriviaParams extends Equatable {
  final int number;
  const GetNumberTriviaParams(this.number);

  @override
  List<Object?> get props => [number];
}

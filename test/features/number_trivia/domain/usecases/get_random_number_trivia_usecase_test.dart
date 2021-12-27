import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TestNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTriviaUseCase? usecase;
  TestNumberTriviaRepository? testNumberTriviaRepository;

  setUp(() {
    testNumberTriviaRepository = TestNumberTriviaRepository();
    usecase = GetRandomNumberTriviaUseCase(testNumberTriviaRepository!);
  });

  const NumberTrivia tNumberTrivia =
      NumberTrivia(text: "Random test", number: 1);

  test('should give random trivia number successfully', () async {
    when(() => testNumberTriviaRepository!.getRandomNumberTrivia()).thenAnswer(
      (_) async => const Right(tNumberTrivia),
    );
    final result = await usecase!();

    expect(result, const Right(tNumberTrivia));
    verify(() => testNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(testNumberTriviaRepository);
  });

  test('should give random trivia number failure', () async {
    when(() => testNumberTriviaRepository!.getRandomNumberTrivia()).thenAnswer(
      (_) async => Left(RemoteFailure("random test fail")),
    );
    final result = await usecase!();
    expect(result, Left(RemoteFailure("random test fail")));
    verify(() => testNumberTriviaRepository!.getRandomNumberTrivia());
    verifyNoMoreInteractions(testNumberTriviaRepository);
  });
}

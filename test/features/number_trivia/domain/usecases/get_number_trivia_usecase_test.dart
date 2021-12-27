import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class TestNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetNumberTriviaUseCase? usecase;
  TestNumberTriviaRepository? testNumberTriviaRepository;

  setUpAll(() {
    testNumberTriviaRepository = TestNumberTriviaRepository();
    usecase = GetNumberTriviaUseCase(testNumberTriviaRepository!);
    registerFallbackValue(const GetNumberTriviaParams(1));
  });

  const int tNumber = 1;
  NumberTrivia tNumberTrivia =
      const NumberTrivia(text: "Test", number: tNumber);

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(
        () => testNumberTriviaRepository!.getNumberTrivia(any(that: isNotNull)),
      ).thenAnswer(
        (_) async => Right(tNumberTrivia),
      );
      // act
      final result = await usecase!(const GetNumberTriviaParams(tNumber));
      // assert
      expect(result, Right(tNumberTrivia));
      verify(() => testNumberTriviaRepository!.getNumberTrivia(tNumber));
      verifyNoMoreInteractions(testNumberTriviaRepository);
    },
  );

  test('should get trivia failure from the repository', () async {
    when(
      () => testNumberTriviaRepository!.getNumberTrivia(
        any(that: isNotNull),
      ),
    ).thenAnswer(
      (_) async => Left(RemoteFailure("Remote Failure")),
    );
    final result = await usecase!(const GetNumberTriviaParams(tNumber));
    //assert
    expect(result, Left(RemoteFailure("Remote Failure")));
    verify(() => testNumberTriviaRepository!.getNumberTrivia(tNumber));
    verifyNoMoreInteractions(testNumberTriviaRepository);
  });
}

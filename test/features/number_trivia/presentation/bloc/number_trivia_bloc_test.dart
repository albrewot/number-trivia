import 'package:bloc_test/bloc_test.dart';
import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/utils/input_converter.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:cleancode/features/number_trivia/presentation/constants/messages/messages.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaBloc
    extends MockBloc<NumberTriviaEvent, NumberTriviaState>
    implements NumberTriviaBloc {}

class MockGetNumberTriviaUseCase extends Mock
    implements GetNumberTriviaUseCase {}

class MockGetRandomNumberTriviaUseCase extends Mock
    implements GetRandomNumberTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockGetNumberTriviaUseCase? numberUseCase;
  MockGetRandomNumberTriviaUseCase? randomUseCase;
  NumberTriviaBloc? numberTriviaBloc;
  MockInputConverter? mockInputConverter;

  setUp(() {
    numberUseCase = MockGetNumberTriviaUseCase();
    randomUseCase = MockGetRandomNumberTriviaUseCase();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      concrete: numberUseCase!,
      random: randomUseCase!,
      converter: mockInputConverter!,
    );
  });

  test(
    'initialState should be empty',
    () async {
      // assert
      expect(numberTriviaBloc!.state, NumberTriviaInitial());
    },
  );

  group("NumberTriviaBloc get number trivia", () {
    const tNumberString = "1";
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    setupSuccessNumberTrivia() {
      when(() => numberUseCase!(any(that: isNotNull)))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    setupFailNumberTrivia() {
      when(() => numberUseCase!(any(that: isNotNull)))
          .thenAnswer((_) async => Left(RemoteFailure(REMOTE_FAILURE)));
    }

    setupSuccessInputConverter() {
      when(() => mockInputConverter!.stringToUint(tNumberString))
          .thenReturn(const Right(tNumberParsed));
    }

    test(
      'should call InputConverter to validate and convert string to uint',
      () async {
        // arrange
        when(() => mockInputConverter!.stringToUint(any(that: isNotNull)))
            .thenReturn(const Right(tNumberParsed));
        // act
        numberTriviaBloc!.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(
          () => mockInputConverter!.stringToUint(any(that: isNotNull)),
        );
        // assert
        verify(() => mockInputConverter!.stringToUint(tNumberString));
      },
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should return input failure",
      build: () {
        when(() => mockInputConverter!.stringToUint(tNumberString))
            .thenReturn(Left(InputFailure()));
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) =>
          bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [const ErrorTrivia(message: INPUT_FAILURE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should invoke getNumberTriviaUseCase",
      build: () {
        setupSuccessInputConverter();
        setupSuccessNumberTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        untilCalled(() => numberUseCase!(any(that: isNotNull)));
      },
      verify: (NumberTriviaBloc bloc) => numberUseCase!(
        const GetNumberTriviaParams(tNumberParsed),
      ),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, LoadedTrivia] when data is gotten successfully",
      build: () {
        setupSuccessInputConverter();
        setupSuccessNumberTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        LoadingTrivia(),
        const LoadedTrivia(trivia: tNumberTrivia),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, ErrorTrivia] when data fails to load",
      build: () {
        setupSuccessInputConverter();
        setupFailNumberTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        LoadingTrivia(),
        const ErrorTrivia(message: REMOTE_FAILURE),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, ErrorTrivia] with proper message when data fails to load",
      build: () {
        setupSuccessInputConverter();
        when(() => numberUseCase!(any(that: isNotNull)))
            .thenAnswer((_) async => Left(LocalFailure(LOCAL_FAILURE)));
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        LoadingTrivia(),
        const ErrorTrivia(message: LOCAL_FAILURE),
      ],
    );
  });
  group("NumberTriviaBloc get Random number trivia", () {
    const tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    setupSuccessRandomTrivia() {
      when(() => randomUseCase!())
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    setupFailRandomTrivia() {
      when(() => randomUseCase!())
          .thenAnswer((_) async => Left(RemoteFailure(REMOTE_FAILURE)));
    }

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should invoke getRandomNumberTrivia",
      build: () {
        setupSuccessRandomTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(GetTriviaForRandomNumber());
        untilCalled(() => randomUseCase!());
      },
      verify: (NumberTriviaBloc bloc) => randomUseCase!(),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, LoadedTrivia] when data is gotten successfully",
      build: () {
        setupSuccessRandomTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        LoadingTrivia(),
        const LoadedTrivia(trivia: tNumberTrivia),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, ErrorTrivia] when data fails to load",
      build: () {
        setupFailRandomTrivia();
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        LoadingTrivia(),
        const ErrorTrivia(message: REMOTE_FAILURE),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      "should emit [LoadingTrivia, ErrorTrivia] with proper message when data fails to load",
      build: () {
        when(() => randomUseCase!())
            .thenAnswer((_) async => Left(LocalFailure(LOCAL_FAILURE)));
        return numberTriviaBloc!;
      },
      act: (NumberTriviaBloc bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => [
        LoadingTrivia(),
        const ErrorTrivia(message: LOCAL_FAILURE),
      ],
    );
  });
}

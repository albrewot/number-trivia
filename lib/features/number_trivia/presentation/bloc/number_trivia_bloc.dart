import 'package:bloc/bloc.dart';
import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/utils/input_converter.dart';
import 'package:cleancode/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:cleancode/features/number_trivia/presentation/constants/messages/messages.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetNumberTriviaUseCase numberTriviaUseCase;
  final GetRandomNumberTriviaUseCase randomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetNumberTriviaUseCase concrete,
    required GetRandomNumberTriviaUseCase random,
    required InputConverter converter,
  })  : numberTriviaUseCase = concrete,
        randomNumberTriviaUseCase = random,
        inputConverter = converter,
        super(NumberTriviaInitial()) {
    on<GetTriviaForConcreteNumber>(
      (event, emit) async {
        final inputEither = inputConverter.stringToUint(event.numberString);

        await emit.forEach(
          inputEither.fold(
            (failure) async* {
              yield const ErrorTrivia(message: INPUT_FAILURE);
            },
            (trivia) async* {
              yield LoadingTrivia();
              final failureOrTrivia =
                  await numberTriviaUseCase(GetNumberTriviaParams(trivia));
              yield failureOrTrivia!.fold(
                (failure) => ErrorTrivia(message: _mapFailureMessage(failure)),
                (trivia) => LoadedTrivia(trivia: trivia),
              );
            },
          ),
          onData: (NumberTriviaState state) => state,
        );
      },
    );
    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(LoadingTrivia());
      final failureOrTrivia = await randomNumberTriviaUseCase();
      await emit.forEach(
          failureOrTrivia.fold(
            (failure) async* {
              yield ErrorTrivia(message: _mapFailureMessage(failure));
            },
            (trivia) async* {
              yield LoadedTrivia(trivia: trivia);
            },
          ),
          onData: (NumberTriviaState state) => state);
    });
  }

  _mapFailureMessage(Failure? failure) {
    switch (failure.runtimeType) {
      case RemoteFailure:
        return REMOTE_FAILURE;
      case LocalFailure:
        return LOCAL_FAILURE;
      default:
        "Unexpected Error";
    }
  }
}

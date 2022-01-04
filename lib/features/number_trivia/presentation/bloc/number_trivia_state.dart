part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class LoadingTrivia extends NumberTriviaState {}

class LoadedTrivia extends NumberTriviaState {
  final NumberTrivia trivia;

  const LoadedTrivia({required this.trivia}) : super();
}

class ErrorTrivia extends NumberTriviaState {
  final String message;

  const ErrorTrivia({required this.message}) : super();
}

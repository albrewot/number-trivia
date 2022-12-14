import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class RemoteFailure extends Failure {
  final String message;
  RemoteFailure(this.message) : super();
}

class LocalFailure extends Failure {
  final String message;
  LocalFailure(this.message) : super();
}

class InputFailure extends Failure {}

import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUint(String str) {
    try {
      int result = int.parse(str);
      if (result.isNegative) {
        return Left(InputFailure());
      }
      return Right(result);
    } on FormatException catch (_) {
      return Left(InputFailure());
    }
  }
}

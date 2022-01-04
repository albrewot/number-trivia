import 'package:cleancode/core/error/failures/failiure.dart';
import 'package:cleancode/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MockInputConverter? mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
  });
  group("InputConverter", () {
    test(
      'should convert string to integer',
      () async {
        // arrange
        String testNumber = "123";
        when(() => mockInputConverter!.stringToUint(any(that: isNotNull)))
            .thenReturn(const Right(123));
        // act
        final result = mockInputConverter!.stringToUint(testNumber);
        // assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return InputFailure while trying to convert invalid String',
      () async {
        // arrange
        String tNumber = "abc";
        when(() => mockInputConverter!.stringToUint(any(that: isNotNull)))
            .thenReturn(Left(InputFailure()));
        // act
        final result = mockInputConverter!.stringToUint(tNumber);
        // assert
        expect(result, Left(InputFailure()));
      },
    );

    test(
      'should return InputFailure while trying to convert negative string number',
      () async {
        // arrange
        String tNumber = "-123";
        when(() => mockInputConverter!.stringToUint(any(that: isNotNull)))
            .thenReturn(Left(InputFailure()));
        // act
        final result = mockInputConverter!.stringToUint(tNumber);
        // assert
        expect(result, Left(InputFailure()));
      },
    );
  });
}

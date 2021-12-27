import 'package:cleancode/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectionChecker extends Mock implements InternetConnectionChecker {}

void main() {
  MockConnectionChecker? mockDataConnectionChecker;
  NetworkInfoImpl? networkInfoImpl;

  setUp(() {
    mockDataConnectionChecker = MockConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker!);
  });

  group("isConnected", () {
    test(
      'should forward the call to DataConnectionChekcer.hasConnection',
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);
        when(() => mockDataConnectionChecker!.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = networkInfoImpl!.isConnected;
        // assert
        verify(() => mockDataConnectionChecker!.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/platform/network_info.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_number/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

num tNumber = null;
NumberTriviaModel tNumberTriviaModel = null;
NumberTrivia tNumberTrivia = null;

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    tNumber = 1;
    tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    tNumberTrivia = tNumberTriviaModel;
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);// calls thenAnswer and returning a Future
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);// calls thenAnswer and returning a Future
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('check if the divece is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer(
          (_) async => true); // calls thenAnswer and returning a Future
      // act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });
  });

  runTestsOnline(() {
    test('return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(Right(tNumberTrivia)));
    });

    test(
        'cache the data locally when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      // act
      await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });

    test(
        'return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
      // act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, equals(Left(ServerFailure())));
    });
  });

  runTestsOffline(() {
    test('return last locally cached data when the cached data is present',
        () async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Right(tNumberTrivia)));
    });

    test('return cache failure when there is no cached present', () async {
      //arrange
      when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}

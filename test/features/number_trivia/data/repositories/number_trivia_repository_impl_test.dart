import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/core/platform/network_info.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia_number/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource {}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

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
      localDataSource:  mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    
    test('check if the divece is online',
    () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true); // calls thenAnswer and returning a Future
      // act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    }
    );
  });
}
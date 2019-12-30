import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences{}

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberLocalDataSourceImpl(mockSharedPreferences);
  });
}
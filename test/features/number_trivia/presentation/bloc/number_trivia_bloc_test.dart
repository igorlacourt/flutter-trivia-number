import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:trivia_number/core/util/input_converter.dart';
import '../../../../../lib/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../../../../../lib/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../../../../lib/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../../../../../lib/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}
class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      input: mockInputConverter
      );
  });

  test('initial should be Empty', (){
    expect(bloc.initialState, equals(Empty()));
  });
}


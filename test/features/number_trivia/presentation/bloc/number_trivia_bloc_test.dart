import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import '../../../../../lib/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import '../../../../../lib/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import '../../../../../lib/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

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
      input: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia  ');

    void setUpInputConverterSuccess() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed)); //thenReturn() used because the operation is synchronous

    test(
        'call the input converter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpInputConverterSuccess();
      // act
      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          // The initial state is always emitted first
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
    
    test(
      'get data from the concrete use case',
      () async {
        //arrange
        setUpInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)) //it's called like a constructor, but it is the call function inside the class
          .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any)); // await the mockGetConcreteNumberTrivia being called
        //assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed))); //it's called like a constructor, but it is the call function inside the class
      }
    );

    test(
      'emit [Loading, Loaded] when data is gotten successfuly',
      () async {
        //arrange
        setUpInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)) //it's called like a constructor, but it is the call function inside the class
          .thenAnswer((_) async => Right(tNumberTrivia));
        //assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        
        //act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      }
    );

  });
}

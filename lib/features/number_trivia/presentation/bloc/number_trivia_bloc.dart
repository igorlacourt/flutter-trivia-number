import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

//This large constructor is necessary because dart doesn't supports non nullable fields.
  NumberTriviaBloc(
      {@required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required InputConverter input})
      : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = input {
    assert(getConcreteNumberTrivia != null);
    assert(getRandomNumberTrivia != null);
    assert(inputConverter != null);
  }

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither = 
          inputConverter.stringToUnsignedInteger(event.numberString);
          
          yield* inputEither.fold(
            (failure) async* {
              yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
            }, 
            (integer) async* {
              yield Loading();
              final failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: integer));
              yield failureOrTrivia.fold(
                  (failure) => Error(message: SERVER_FAILURE_MESSAGE),
                  (trivia) => Loaded(trivia: trivia)
                );
            }
          );
    }
  }
}

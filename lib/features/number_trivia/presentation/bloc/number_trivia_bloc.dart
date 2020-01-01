import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

//This large constructor is necessary because dart doesn't supports non nullable fields.
  NumberTriviaBloc({
      @required GetConcreteNumberTrivia concrete,
      @required GetRandomNumberTrivia random,
      @required InputConverter input
  }) : 
  assert(getConcreteNumberTrivia != null),
  assert(getRandomNumberTrivia != null),
  assert(inputConverter != null),  
  getConcreteNumberTrivia = concrete, 
  getRandomNumberTrivia = random,
  inputConverter = input;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

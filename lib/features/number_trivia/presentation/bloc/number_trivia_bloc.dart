import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:trivia_number/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  @override
  NumberTriviaState get initialState => InitialNumberTriviaState();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

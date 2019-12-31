import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NewTriviaBloc extends Bloc<NewTriviaEvent, NewTriviaState> {
  @override
  NewTriviaState get initialState => InitialNewTriviaState();

  @override
  Stream<NewTriviaState> mapEventToState(
    NewTriviaEvent event,
  ) async* {
    // TODO: Add Logic
  }
}

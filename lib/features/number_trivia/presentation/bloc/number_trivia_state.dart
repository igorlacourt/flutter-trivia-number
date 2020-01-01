import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]) : super(props);
}

class InitialNumberTriviaState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

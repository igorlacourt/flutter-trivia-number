import 'package:equatable/equatable.dart';

abstract class NewTriviaState extends Equatable {
  const NewTriviaState();
}

class InitialNewTriviaState extends NewTriviaState {
  @override
  List<Object> get props => [];
}

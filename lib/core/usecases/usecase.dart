import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:trivia_number/core/error/failures.dart';

abstract class UseCase<Type,  Params>{
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {}
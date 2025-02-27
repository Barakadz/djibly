// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../../../../models/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser extends UseCase<User, NoParams> {
  final AuthRepository repository;
  GetCurrentUser({
    this.repository,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params) async {}
}

class NoParams {
  @override
  List<Object> get props => [];
}

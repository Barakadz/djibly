import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../../../../models/user.dart';
import '../repositories/auth_repository.dart';
import 'get_current_user.dart';

class SignIn extends UseCase<void, String> {
  final AuthRepository repository;
  SignIn({
    this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await repository.login(params);
  }
}

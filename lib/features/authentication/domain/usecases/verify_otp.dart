import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../repositories/auth_repository.dart';
import 'get_current_user.dart';

class VerifyOtp extends UseCase<void, String> {
  final AuthRepository repository;
  VerifyOtp({
    this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await repository.verifyOtp(params, params);
  }
}

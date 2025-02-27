import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../repositories/auth_repository.dart';
import 'get_current_user.dart';

class SendOtp extends UseCase<void, String> {
  final AuthRepository repository;
  SendOtp({
    this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    print("------------------- SendOtp ------------------- ");
    return await repository.sendOtp(params);
  }
}

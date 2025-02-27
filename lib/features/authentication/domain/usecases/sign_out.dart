import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../repositories/auth_repository.dart';
import 'get_current_user.dart';

class SignOut extends UseCase<void, void> {
  final AuthRepository repository;
  SignOut({
    this.repository,
  });

  @override
  Future<Either<Failure, bool>> call(void params) async {
    return await repository.logout();
  }
}

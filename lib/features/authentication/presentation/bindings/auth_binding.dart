import 'package:dio/dio.dart';
import 'package:djibly/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:djibly/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:djibly/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/get_current_user.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio();
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dio);
    final authRepository =
        AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    Get.lazyPut(() => AuthController(
        sendOtpUsecase: SendOtp(repository: authRepository),
        verifyOtpUsecase: VerifyOtp(repository: authRepository),
        signInUsecase: SignIn(repository: authRepository),
        signOutUsecase: SignOut(repository: authRepository),
        getCurrentUserUsecase: GetCurrentUser(repository: authRepository)));
  }
}

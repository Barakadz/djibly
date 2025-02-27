import 'package:dartz/dartz.dart';
import 'package:djibly/features/authentication/domain/entities/user.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../../../../models/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, dynamic>> login(String phone);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, dynamic>> sendOtp(String phone);
  Future<Either<Failure, dynamic>> verifyOtp(String phone, String otp);
  Future<Either<Failure, dynamic>> register(Map<String, dynamic> body);
}

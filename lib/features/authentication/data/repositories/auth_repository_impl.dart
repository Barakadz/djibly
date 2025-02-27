import 'package:dartz/dartz.dart';
import '../../../../app/core/errors/fealure.dart/fealure.dart';
import '../../../../models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSource;
  final AuthDataSource localDataSource;

  AuthRepositoryImpl({
    this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> register(Map<String, dynamic> body) async {
    try {
      final response = await remoteDataSource.register(body);
      return right(response);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> sendOtp(String phone) async {
    try {
      final response = await remoteDataSource.sendOtp(phone);
      return right(true);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> login(String phone) async {
    try {
      final response = await remoteDataSource.login(phone);
      return right(response);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final response = await remoteDataSource.logout();
      return right(response);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> verifyOtp(String phone, String otp) async {
    try {
      final response = await remoteDataSource.verifyOtp(phone, otp);
      return right(true);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}

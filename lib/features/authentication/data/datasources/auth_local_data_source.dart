// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/src/response.dart';
import 'package:djibly/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSourceImpl implements AuthDataSource {
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl({
    this.sharedPreferences,
  });

  @override
  Future<void> createUser(String name, String phoneNumber) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<Response> login(String phone) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendOtp(String phoneNumber) {
    // TODO: implement sendOtp
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp(String phoneNumber, String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
  
  @override
  Future<Response> register(Map<String, dynamic> body) {
    // TODO: implement register
    throw UnimplementedError();
  }
}

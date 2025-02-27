import 'dart:convert';

import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/server_response.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

AuthProvider authProvider;

class User {

  User user;

  int id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String profilePicture;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone'],
      email: json['email'],
      profilePicture: json['profile_picture'],
    );
  }

  static Future<bool> refreshUserNotification(data) async {
    try {
      http.Response response =
          await Network.postWithToken('/notification/token', data);
      print(response.body);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}

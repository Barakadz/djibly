import 'dart:convert';

import 'package:djibly/models/user.dart';
import 'package:djibly/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePresenter with ChangeNotifier {
  bool isLoading = false;
  bool errorFetching = false;
  User user;

  Future<User> getUser() async {
    if (user != null) {
      return user;
    } else {
      final storage = await SharedPreferences.getInstance();

      String StringUser = storage.getString("user");
      if (StringUser != null) {
        try {
          user = User.fromJson(json.decode(utf8.decode(StringUser.codeUnits)));

          return user;
        } catch (exception) {
          storage.remove("user");
          return null;
        }
      } else {
        await fetchUser();
      }
    }
  }

  void getUserFromStorage() async {
    var storage = await SharedPreferences.getInstance();
    // final data = await ProfilePresenter().getUser();
    // user = data;
    user.firstName = storage.get('first_name');
    user.lastName = storage.get('last_name');
    user.email = storage.get('email');
    user.profilePicture = storage.get('profile_picture');
    print("🟢🟢🟢 ############## USER ${user.firstName}");
    print("🟢🟢🟢 ############## USER ${user.lastName}");
    print("🟢🟢🟢 ############## USER ${user.email}");
    print("🟢🟢🟢 ############## USER ${user.profilePicture}");
    notifyListeners();
  }

  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();
    final response = await UserRepository.getUser();
    if (response.statusCode == 200) {
      print("🟢🟢🟢 ############## USER ${response.body}");

      final result = json.decode(utf8.decode(response.bodyBytes));
      user = User.fromJson(result['data']['user']);
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.setString('first_name', user.firstName);
      await storage.setString('last_name', user.lastName);
      await storage.setString('email', user.email);
      await storage.setString('profile_picture', user.profilePicture);

      notifyListeners();
      print("🟢🟢🟢 ############## USER ${user.firstName}");
      errorFetching = false;
    } else {
      errorFetching = true;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserInformation(firstName, lastName, email) async {
    Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
    print("🔃�� ############## updateUserInformation data ${data}");
    final response = await UserRepository.updateProfile(data);
    if (response.statusCode == 200) {
      await setUser(response.body);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfilePicture(filePath) async {
    var response =
        await UserRepository.updateProfilePicture('profile_picture', filePath);

    if (response != null) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 200) {
        await setUser(responseString);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void setUser(String responseString) async {
    Map<String, dynamic> userMap =
        json.decode(utf8.decode(responseString.codeUnits))['data']['user'];
    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('user', json.encode((userMap)));
    user = User.fromJson(userMap);
    await storage.setString('first_name', user.firstName);
    await storage.setString('last_name', user.lastName);
    await storage.setString('email', user.email);
    await storage.setString('profile_picture', user.profilePicture);
  }
}

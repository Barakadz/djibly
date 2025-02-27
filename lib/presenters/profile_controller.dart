import 'dart:convert';
import 'package:djibly/models/user.dart';
import 'package:djibly/repositories/user_repository.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController with StateMixin<User> {
  // Convert to observable variables
  final _isLoading = false.obs;
  final _errorFetching = false.obs;
  final Rx<User> _user = Rx<User>(User());

  // Getters
  bool get isLoading => _isLoading.value;
  bool get errorFetching => _errorFetching.value;
  User get user => _user.value;

  @override
  void onInit() async {
    super.onInit();
    if (!isLoading) await getUser();
  }

  Future<User> getUser() async {
    if (_user.value != null) {
      return _user.value;
    }

    final storage = await SharedPreferences.getInstance();
    String stringUser = storage.getString("user");

    if (stringUser != null) {
      try {
        _user.value =
            User.fromJson(json.decode(utf8.decode(stringUser.codeUnits)));
        await _saveUserToPrefs(_user.value);
        return _user.value;
      } catch (exception) {
        storage.remove("user");
        return null;
      }
    } else {
      await fetchUser();
      return _user.value;
    }
  }

  Future<void> fetchUser() async {
    _isLoading.value = true;
    final response = await UserRepository.getUser();

    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes));
      _user.value = User.fromJson(result['data']['user']);
      await _saveUserToPrefs(_user.value);
      _errorFetching.value = false;
    } else {
      _errorFetching.value = true;
    }

    _isLoading.value = false;
  }

  Future<bool> updateUserInformation(
      String firstName, String lastName, String email) async {
    final response = await UserRepository.updateProfile({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    });

    if (response.statusCode == 200) {
      await setUser(response.body);
      return true;
    }
    return false;
  }

  Future<bool> updateProfilePicture(String filePath) async {
    final response =
        await UserRepository.updateProfilePicture('profile_picture', filePath);

    if (response != null) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        await setUser(responseString);
        return true;
      }
    }
    return false;
  }

  Future<void> setUser(String responseString) async {
    Map<String, dynamic> userMap =
        json.decode(utf8.decode(responseString.codeUnits))['data']['user'];
    final storage = await SharedPreferences.getInstance();
    await storage.setString('user', json.encode(userMap));
    _user.value = User.fromJson(userMap);
    await _saveUserToPrefs(_user.value);
  }

  Future<void> _saveUserToPrefs(User user) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString('first_name', user.firstName);
    await storage.setString('last_name', user.lastName);
    await storage.setString('email', user.email);
    await storage.setString('profile_picture', user.profilePicture);
  }
}

# djibly

A Flutter project implementing Test-Driven Development (TDD) and Clean Architecture principles.

## Project Overview

This project demonstrates a robust, maintainable, and testable Flutter application. It strictly adheres to TDD practices and incorporates a clean, layered architecture.

## Architecture

The project follows a clean architecture with the following layers:

1. **Presentation Layer**: UI components and state management (using GetX)
2. **Domain Layer**: Business logic and use cases
3. **Data Layer**: Data sources, repositories, and external services

## Project Structure

```
lib/
├── core/
│   ├── error/
│   ├── usecases/
│   └── util/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_data_source.dart
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_user.dart
│   │   │       ├── sign_in.dart
│   │   │       └── sign_out.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   └── other_features/
└── main.dart

test/
├── features/
│   └── authentication/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── core/
```


lib/core/error/.gitkeep
lib/core/usecases/.gitkeep
lib/core/util/.gitkeep
lib/features/authentication/data/datasources/auth_local_data_source.dart
lib/features/authentication/data/datasources/auth_remote_data_source.dart
lib/features/authentication/data/models/user_model.dart
lib/features/authentication/data/repositories/auth_repository_impl.dart
lib/features/authentication/domain/entities/user.dart
lib/features/authentication/domain/repositories/auth_repository.dart
lib/features/authentication/domain/usecases/get_current_user.dart
lib/features/authentication/domain/usecases/sign_in.dart
lib/features/authentication/domain/usecases/sign_out.dart
lib/features/authentication/domain/usecases/send_otp.dart
lib/features/authentication/domain/usecases/verify_otp.dart
lib/features/authentication/presentation/controllers/auth_controller.dart
lib/features/authentication/presentation/pages/login_page.dart
lib/features/authentication/presentation/pages/otp_page.dart
lib/features/authentication/presentation/pages/profile_page.dart
lib/features/authentication/presentation/widgets/login_form.dart
lib/features/authentication/presentation/widgets/otp_form.dart
lib/routes/app_pages.dart
lib/main.dart
test/features/authentication/data/.gitkeep
test/features/authentication/domain/.gitkeep
test/features/authentication/presentation/.gitkeep
test/core/.gitkeep


### Authentication Feature Example

The authentication feature demonstrates how a typical feature is structured within the clean architecture using GetX, including OTP functionality:

1. **Data Layer**:

   - `auth_local_data_source.dart`: Handles local storage of auth data (e.g., tokens)
   - `auth_remote_data_source.dart`: Manages API calls for authentication and OTP
   - `user_model.dart`: Data model for user information
   - `auth_repository_impl.dart`: Implements the repository interface

2. **Domain Layer**:

   - `user.dart`: Entity representing a user
   - `auth_repository.dart`: Abstract definition of auth repository
   - Use cases:
     - `get_current_user.dart`: Retrieves the current authenticated user
     - `sign_in.dart`: Handles user sign-in
     - `sign_out.dart`: Manages user sign-out
     - `send_otp.dart`: Sends OTP to user's phone or email
     - `verify_otp.dart`: Verifies the OTP entered by the user

3. **Presentation Layer**:

   - GetX Controller for state management:
     - `auth_controller.dart`: Manages authentication state and logic, including OTP
   - Pages:
     - `login_page.dart`: Login screen
     - `otp_page.dart`: OTP entry screen
     - `profile_page.dart`: User profile screen
   - Widgets:
     - `login_form.dart`: Reusable login form widget
     - `otp_form.dart`: Reusable OTP entry form widget

4. **Routes**:
   - `app_pages.dart`: Defines the routes for the application using GetX routing

## GetX Integration

Example of a GetX controller with OTP functionality (`auth_controller.dart`):

```
import 'package:get/get.dart';
import '../../../domain/usecases/sign_in.dart';
import '../../../domain/usecases/send_otp.dart';
import '../../../domain/usecases/verify_otp.dart';

class AuthController extends GetxController {
  final SignIn _signIn;
  final SendOTP _sendOTP;
  final VerifyOTP _verifyOTP;

  AuthController(this._signIn, this._sendOTP, this._verifyOTP);

  final _user = Rx<User?>(null);
  User? get user => _user.value;

  final _otpSent = false.obs;
  bool get otpSent => _otpSent.value;

  Future<void> signIn(String email, String password) async {
    final result = await _signIn(SignInParams(email: email, password: password));
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (user) => _user.value = user
    );
  }

  Future<void> sendOTP(String phoneNumber) async {
    final result = await _sendOTP(SendOTPParams(phoneNumber: phoneNumber));
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) {
        _otpSent.value = true;
        Get.toNamed('/otp');
      }
    );
  }

  Future<void> verifyOTP(String otp) async {
    final result = await _verifyOTP(VerifyOTPParams(otp: otp));
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (user) {
        _user.value = user;
        Get.offAllNamed('/profile');
      }
    );
  }

  // Other authentication methods...
}
```

This structure allows for easy testing and separation of concerns while taking advantage of GetX's features, including OTP functionality.

## Test-Driven Development Approach

This project strictly follows TDD principles:

1. Write a failing test for a small piece of functionality
2. Implement the minimum code to make the test pass
3. Refactor the code while ensuring all tests continue to pass
4. Repeat for each new feature or functionality

## Getting Started

To run this project:

1. Ensure you have Flutter installed and set up.
2. Clone this repository.
3. Run `flutter pub get` to install dependencies.
4. Use `flutter run` to start the application.

## Running Tests

Execute tests using the following command:

```
flutter test
```

To run tests with coverage:

```
flutter test --coverage
```

## Best Practices

- Write tests for all layers: data, domain, and presentation
- Keep functions small and focused
- Use dependency injection for better testability
- Follow SOLID principles

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Clean Architecture with Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)
- [Effective Dart: Style Guide](https://dart.dev/guides/language/effective-dart/style)

## Contributing

Please read our [CONTRIBUTING.md](CONTRIBUTING.md) file for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the [MIT License](LICENSE).

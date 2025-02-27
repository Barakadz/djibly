import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginForm extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller.phoneNumberController,
        ),
      ],
    );
  }
}

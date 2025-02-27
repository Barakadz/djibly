import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../helpers/styles.dart';
import '../bindings/auth_binding.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login_form.dart';
import '../../../../app/core/extensions/list_extension.dart';
import '../../../../ui/components/buttons/rounded_elevated_button.dart';
import '../../../../utilities/common_styles.dart';
import '../../../../utilities/constants.dart';
import '../../../../utilities/validate.dart';

class LoginPage extends GetView<AuthController> {
  LoginPage({Key key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("------------------- LoginPage ------------------- ");
    AuthBinding().dependencies();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 32),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppLocalizations.of(context).phone_number_text,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: controller.phoneNumberController,
                              onFieldSubmitted: (_) => controller.signIn(
                                  controller.phoneNumberController.text),
                              decoration: inputDecorationStyle(
                                prefixIcon: Icons.phone_android_sharp,
                              ),
                              validator: (value) =>
                                  Validate.validatePhone(value?.trim() ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(() => CustomRoundedElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => controller.sendOtp(
                                          controller.phoneNumberController.text,
                                        ),
                                buttonColor: DjiblyColor,
                                isDisabled: controller.isLoading.value,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .send_text
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )),
                        ),
                        const SizedBox(height: 16),
                        FormField<bool>(
                          validator: (_) => controller.checkboxValue.value
                              ? null
                              : AppLocalizations.of(context)
                                  .accept_privacy_error_text,
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: controller.checkboxValue.value,
                                      fillColor: MaterialStateProperty.all(
                                          DjiblyColor),
                                      onChanged: (value) {
                                        controller.checkboxValue.value =
                                            value ?? false;
                                        state.didChange(value);
                                      },
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => controller
                                            .launchPrivacyPolicy(context),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .accept_privacy_text,
                                          style:
                                              context.text.labelLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (state.hasError)
                                  Text(
                                    state.errorText ?? '',
                                    style: context.text.labelLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ].addSeparators(const SizedBox(height: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

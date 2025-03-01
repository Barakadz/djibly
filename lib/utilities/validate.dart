import 'dart:core';
import 'package:djibly/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validate {
  // RegEx pattern for validating email addresses.
  static Pattern emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  static Pattern patternPhone = r"/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/";
  static RegExp emailRegEx = RegExp(emailPattern);
  static bool isEmail(String value) {
    if (emailRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }

  static bool isPhoneNumber(String value) {
    if (value.trim().length == 9 || value.trim().length == 10) {
      return true;
    }
    return false;
  }

  /*
   * Returns an error message if email does not validate.
   */
  static String validateEmail(String value) {
    String email = value.trim();
    if (email.isEmpty) {
      return 'Email is required.';
    }
    if (!isEmail(email)) {
      return 'Valid email required.';
    }
    return null;
  }

  static String validatePhone(String value) {
    String phone = value.trim();
    if (phone.isEmpty) {
      return AppLocalizations.of(MyApp.navigatorKey.currentContext).phone_number_empty_error;
    }

    if (phone.length != 9 && phone.length != 10) {
      return AppLocalizations.of(MyApp.navigatorKey.currentContext).phone_number_not_valid_error;
    }
    return null;
  }

  static String validateOtp(String value){
    if (value.isEmpty || value.length != 6) {
      return 'Veuillez entrer un code valide à 6 chiffres';
    }
    return null;
  }

  static String requiredField(String value, String message) {
    if (value.trim().isEmpty || value.trim().length <= 2) {
      return message;
    }
    return null;
  }

  static String requiredPasseword(String value, String message) {
    if (value.trim().isEmpty || value.trim().length < 6) {
      return message;
    }
    return null;
  }

  static String requiredCondition(bool value, String message) {
    if (value == false) {
      return message;
    }
    return null;
  }

  static String requiredPassewordConfirmation(
      String value, String mdpCon, String message) {
    if (value.trim().length != mdpCon.length) {
      return 'Confirmation mot de passe est invalide';
    } else {
      if (value.trim().isEmpty || value.trim().length < 6) {
        return message;
      }
    }
    return null;
  }

  static String validateFirstName(String value) {
    String firstName = value.trim();
    if (firstName.isEmpty) {
      return 'The first name is required';
    }
    if (firstName.length < 2) {
      return 'The first name is invalid';
    }
    return null;
  }
}

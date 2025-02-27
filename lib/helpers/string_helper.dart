import 'dart:core';
import 'package:djibly/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension PhoneNumberFormatting on String {
  String toDjezzyPhoneNumber() {
    if (this.length == 9) {
      return '${this.substring(0, 3)} ${this.substring(3, 5)} ${this.substring(5, 7)} ${this.substring(7, 9)}';
    } else {
      throw FormatException("Invalid Djezzy phone number");
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isNotEmpty) {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } else {
      return this; // Return the original string if it's empty
    }
  }

  String toTitleCase() {
    return replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((str) => str.capitalize())
        .join(' ');
  }

  String toHumanDate() {
    // Get the current locale.
    final Locale locale =
        Localizations.localeOf(MyApp.navigatorKey.currentContext);
    String language = locale.languageCode + "_" + locale.countryCode;
    DateTime dateTime = DateTime.parse(this);
    final DateFormat formatter = DateFormat('MMMM yyyy', language);
    return formatter.format(dateTime);
  }

  String toDateFormat(String dateFormat, String date) {
    final DateTime now = DateTime.parse(date).add(Duration(hours: 1));

    final DateFormat formatter = DateFormat(dateFormat);

    return DateFormat.yMEd().add_jms().format(now);
  }

  String toDateTimeFormat() {
    final DateTime now = DateTime.parse(this).add(Duration(hours: 1));
    final DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(now);
  }
}

extension DoubeExtension on double {
  String toDZD() {
    return "${(this.toStringAsFixed(0)) + " ${AppLocalizations.of(MyApp.navigatorKey.currentContext).dz_money} "}";
  }

  String toDZDMoney() {
    return "${this.toStringAsFixed(0) + " " + AppLocalizations.of(MyApp.navigatorKey.currentContext).dz_money}";
  }
}

class StringHelper {
  static String toDZD(double value) {
    return "${value.toStringAsFixed(0) + " " + AppLocalizations.of(MyApp.navigatorKey.currentContext).dz_money}";
  }
}

import 'package:flutter/material.dart';

const kTitleTextStyle = TextStyle(
  fontSize: 15.0,
  fontFamily: 'Spartan MB',
  fontWeight: FontWeight.bold,
  color: Color(0xFF4a9ef5),
);
const KSubtitleStyle = TextStyle(
  fontSize: 12.0,
  fontFamily: 'Spartan MB',
  color: Color(0xFFC1C1C1),
);

const DjiblyColor = Color(0xFFE31D1A);
const LinksColor = Color(0xFF0047FF);

// *** Regex
final nameRegex = RegExp(r'^[^<>&;"/\\(){}[\]]+$', unicode: true);
final addressRegex = RegExp(r'^[^<>&;"/\\(){}[\]]+$', unicode: true);

final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
final algerianPhoneRegex =
    RegExp(r'^\(?(\d{3})\)?[-. ]?(\d{3})[-. ]?(\d{3,4})$');

final kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
    fontSize: 15.0);

final kColorDarkGray = Color(0xFF4F4F4F);
final kColorLightGray = Color(0xFFc9c9c9);
final kColorDarkBlue = Color(0xFF4A83F5);
final kColorDeepBlue = Color(0xFF004D99);
final kColorLightBlue = Color(0xFF43B6EB);
// ignore: non_constant_identifier_names
final KColorGray = Colors.grey[200];

const String PrivacyURL =
    "https://www.djezzy.dz/conditions-generales-dutilisation-de-lapplication-mobile-djibly/";
const String ArabicPrivacyURL =
    "https://www.djezzy.dz/ar/conditions-generales-dutilisation-de-lapplication-mobile-djibly-va/";
const String LiveChat = "https://www.djezzy.dz/livechat";

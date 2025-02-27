import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static Future<String> getFingerprint() async {
    String fingerprint = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      fingerprint += androidInfo.fingerprint;
    }
    if (Platform.isIOS) {
      IosDeviceInfo androidInfo = await deviceInfo.iosInfo;
      fingerprint += androidInfo.identifierForVendor;
    }
    return fingerprint;
  }

  static Future<String> getDevice() async {
    String device = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device += androidInfo.brand + " " + androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo androidInfo = await deviceInfo.iosInfo;
      device += androidInfo.name + " " + androidInfo.model;
    }

    return device;
  }

  static Future<String> userAgent() async {
    String userAgent = "";
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      userAgent = packageInfo.appName + "/" + packageInfo.version;
    } catch (e) {}
    return userAgent;
  }
}

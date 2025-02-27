import 'dart:convert';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ServerResponse {
  static final context = MyApp.navigatorKey.currentContext;

  static serverResponseHandler({http.Response response}) async {
    switch (response.statusCode) {
      case 401:
        await Provider.of<AuthProvider>(context, listen: false)
            .redirectToLogin();
        break;
      case 500:
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.something_went_wrong_body);
        break;
      case 408:
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.connection_problem_body);
        break;
      default:
        try {
          ToastService.showErrorToast(json.decode(response.body)['message']);
        } catch (e) {
          ToastService.showErrorToast(MyApp
              .navigatorKey.currentContext.translate.something_went_wrong_body);
        }
        break;
    }
  }

  static serverStreamedResponseHandler({http.StreamedResponse response}) async {
    switch (response.statusCode) {
      case 401:
        await Provider.of<AuthProvider>(context, listen: false)
            .redirectToLogin();
        break;
      case 500:
        ToastService.showErrorToast(MyApp
            .navigatorKey.currentContext.translate.something_went_wrong_body);
        break;
      default:
        final responseData = await response.stream.toBytes();
        final body = String.fromCharCodes(responseData);
        
        ToastService.showErrorToast(json.decode(body)['message']);
        break;
    }
  }
}

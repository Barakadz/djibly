import 'package:flutter/material.dart';

class LoaderProvider extends ChangeNotifier {
  var _loader = false;
  bool get getLoader {
    return _loader;
  }

  void setLoader(bool value) {
    _loader = value;
    notifyListeners();
  }
}
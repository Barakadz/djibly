import 'package:flutter/material.dart';

InputDecoration inputDecorationStyle({IconData prefixIcon}) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 1,
      ),
    ),
    focusColor: Colors.blue,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    errorMaxLines: 2,
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    filled: true,
    fillColor: Colors.grey.shade100,
    prefixIcon: Icon(prefixIcon),
  );
}

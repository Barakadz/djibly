import 'package:flutter/material.dart';

class CustomTextAlert{

  static showAlert(BuildContext context, List<Widget> actionbuttons, String content, String title){

      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actionbuttons,
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );

  }
}

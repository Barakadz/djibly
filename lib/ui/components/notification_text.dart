import 'package:flutter/material.dart';

class NotificationText extends StatelessWidget {
  final String text;
  final String type;
  NotificationText(this.text, {this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Colors.red[700];
    double size = 14.0;
    if (this.type == 'errors') {
      size = 20.0;
      color = Colors.red[700];
      return Container(
        alignment: Alignment.center,
        height: 45.0,
        color: Colors.white.withOpacity(0.5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: size),
        ),
      );
    } else if (this.type == 'message') {
      size = 20.0;
      color = Colors.lightGreen[700];
      return Container(
        alignment: Alignment.center,
        height: 45.0,
        color: Colors.white.withOpacity(0.7),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: size),
        ),
      );
    }
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}

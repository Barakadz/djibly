import 'package:flutter/material.dart';

class ProductTabWidget extends StatelessWidget {
  String title;
  Color backgroundColor;
  Color textColor;
  Function action;
  ProductTabWidget(
      {Key key, this.title, this.backgroundColor, this.textColor, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null
        ? SizedBox(width: 0.0, height: 0.0)
        : ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.45, 50)),
              textStyle: MaterialStateProperty.all(
                TextStyle(
                  color: textColor,
                ),
              ),
            ),
            onPressed: action,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                  fontWeight: FontWeight.bold),
            ),
          );
  }
}

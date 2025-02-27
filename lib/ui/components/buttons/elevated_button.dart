import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Color textColor;
  final Color buttonColor;
  final bool isDisabled;
  final double radius;

  const CustomElevatedButton(
      {Key key,
      this.child,
      this.onPressed,
      this.radius = 4,
      this.textColor = Colors.white,
      this.buttonColor,
      this.isDisabled})
      : super(key: key);

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton> {
  Widget buttonwidget;
  bool isDisabledBtn;

  @override
  void initState() {
    buttonwidget = widget.child;
    isDisabledBtn = widget.isDisabled ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        color: widget.buttonColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12,
        ),
        child: InkWell(
            onTap: isDisabledBtn
                ? null
                : () async {
                    setState(() {
                      isDisabledBtn = true;
                      buttonwidget = SizedBox(
                        height: 15.0,
                        width: 15.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white24),
                          strokeWidth: 6.0,
                        ),
                      );
                    });
                    await widget.onPressed.call();
                    setState(() {
                      isDisabledBtn = false;
                      buttonwidget = widget.child;
                    });
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[widget.child],
            )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomRoundedElevatedButton extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final Color textColor;
  final Color buttonColor;
  final bool isDisabled;
  const CustomRoundedElevatedButton(
      {Key key,
      this.child,
      this.onPressed,
      this.textColor = Colors.white,
      this.buttonColor,
      this.isDisabled})
      : super(key: key);

  @override
  CustomRoundedElevatedButtonState createState() => CustomRoundedElevatedButtonState();
}

class CustomRoundedElevatedButtonState extends State<CustomRoundedElevatedButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isDisabled);
    final buttonWidth = MediaQuery.of(context).size.width * 0.6;
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: widget.isDisabled
            ? null
            : () async {
                await widget.onPressed.call();
              },
        child: !widget.isDisabled ? widget.child : SizedBox(
          height: 15.0,
          width: 15.0,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          fixedSize: Size(buttonWidth, 45),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          backgroundColor: widget.buttonColor,
          disabledBackgroundColor: widget.buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }
}

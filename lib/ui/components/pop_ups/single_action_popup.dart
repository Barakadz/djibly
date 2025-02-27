import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';

class SingleActionPopup extends StatelessWidget {
  Function action;
  IconData iconData;
  String title;
  String body;

  SingleActionPopup(
      {Key key, this.action, this.iconData, this.title, this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "$title",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              iconData,
              color: DjiblyColor,
              size: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$body",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomRoundedElevatedButton(
              onPressed: action,
              buttonColor: DjiblyColor,
              isDisabled: false,
              child: Text(
                'Fermer',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
          )
        ],
      ),
    );
  }
}

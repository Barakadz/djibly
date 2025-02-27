import 'package:djibly/pages/slider/slider_page.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:flutter/material.dart';

import 'package:djibly/utilities/constants.dart';

class WelcomePage extends StatefulWidget {
  static const String routeName = 'welcome_page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          //color: Color(0xFFEDEDED),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/particulier-rounded.png",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomElevatedButton(
        buttonColor: DjiblyColor,
        isDisabled: false,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(SliderPage.routeName);
        },
        child: Text(
          'DÉMARRER'.toUpperCase(),
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

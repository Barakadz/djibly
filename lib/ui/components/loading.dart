import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:djibly/providers/auth_provider.dart';

class Loading extends StatelessWidget {
  // ignore: non_constant_identifier_names

  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    initAuthProvider(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "assets/images/logo_djibly_2.png",
                width: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 6.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

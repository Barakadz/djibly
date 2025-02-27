import 'dart:io';

import 'package:flutter/material.dart';

class CircleAvatarPlaceholder extends StatelessWidget {
  const CircleAvatarPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 140.0,
      backgroundColor: Colors.white,
      child: Image.asset('assets/images/user-avatar.png'),
    );
  }
}

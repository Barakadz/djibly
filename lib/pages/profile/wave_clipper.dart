import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height - 25);

    var p1 = Offset(size.width / 3, size.height - 10);
    var p2 = Offset(size.width / 2.25, size.height - 10);

    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);

    var p3 = Offset(size.width - (size.width / 3.5), size.height - 10 );
    var p4 = Offset(size.width , size.height - 45);
    //
    path.quadraticBezierTo(p3.dx, p3.dy, p4.dx, p4.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

import 'package:flutter/material.dart';

class HomeCarouselPlaceholder extends StatelessWidget {
  const HomeCarouselPlaceholder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/carousel_placeholder.png",
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}

import 'package:djibly/pages/auth/auth_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderPage extends StatefulWidget {
  static const String routeName = 'slider_page';

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  int _page = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _page, keepPage: true);
  }

  void _forward() {
    if (_page <= 1) {
      setState(() {
        _page++;
        _pageController.animateToPage(
            _page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    } else {
      Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
    }
  }

  void _back() {
    if (_page >= 0) {
      setState(() {
        _page--;
        _pageController.animateToPage(
          _page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: _pageController,
        children: [getPage('slider1'), getPage('slider2'), getPage('slider3')],
      )),
    );
  }

  Widget getPage(slider) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Card(
            //color: Colors.amber,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height * 0.8,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/images/$slider.png",
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _back,
                          child: Container(
                            child: Image.asset('assets/images/back.png'),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: _forward,
                          child: Container(
                            child: Image.asset('assets/images/forward.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

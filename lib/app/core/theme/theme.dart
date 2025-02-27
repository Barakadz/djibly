import 'light_theme.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: lightColorSchema,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
    selectedLabelStyle: TextStyle(
      height: 1.5,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    unselectedLabelStyle: TextStyle(
      height: 1.5,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
  ),
  dividerTheme: DividerThemeData(thickness: .0),
  scaffoldBackgroundColor: lightColorSchema.background,
  appBarTheme: AppBarTheme(
      color: lightColorSchema.surface,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      centerTitle: false,
      elevation: 0),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransition(),
      TargetPlatform.iOS: CustomPageTransition(),
    },
  ),
);

class CustomPageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}

import 'dart:io';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/models/order.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/presenters/add_to_cart_presenter.dart';
import 'package:djibly/presenters/home/home_tab_presenter.dart';
import 'package:djibly/presenters/home_presenter.dart';
import 'package:djibly/presenters/local_controller.dart';
import 'package:djibly/presenters/order_presenter.dart';
import 'package:djibly/presenters/nearby_pos_presenter.dart';
import 'package:djibly/presenters/pos_presenter.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/presenters/profile_presenter.dart';
import 'package:djibly/presenters/search_presenter.dart';
import 'package:djibly/presenters/wishlist_presenter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:djibly/utilities/routes.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app/core/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ),
  );

  await Firebase.initializeApp(
    name: "djibly-user",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  HttpOverrides.global = new MyHttpOverrides();

  // Add custom error widget
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return FeedbackErrorWidget(errorDetails: errorDetails);
  };

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  @override
  Widget build(BuildContext context) {
    return GetX<LocaleController>(
      init: LocaleController(),
      initState: (_) {},
      builder: (controller) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AuthProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => CartPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => ProfilePresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => Order(),
            ),
            ChangeNotifierProvider(
              create: (context) => UserAddress(),
            ),
            ChangeNotifierProvider(
              create: (context) => CreateOrderPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => NearbyPosPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => PosPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => HomePresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeTabPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => SearchPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => ProductDetailsPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => AddToCartPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => OrderPresenter(),
            ),
            ChangeNotifierProvider(
              create: (context) => WishlistPresenter(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: controller.locale.value,
            themeMode: ThemeMode.light,

            // locale: Locale("fr"),
            title: 'Djibly',

            initialRoute: '/',
            theme: lightTheme,

            routes: routes,
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class FeedbackErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const FeedbackErrorWidget({Key key, this.errorDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                    onPressed: () {
                      // Return to the previous page
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      context.translate.return_text,
                      style: TextStyle(
                        color: Colors.white,
                      ),
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

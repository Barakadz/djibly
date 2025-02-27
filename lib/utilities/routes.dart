import 'package:djibly/pages/addresses/add_address/add_address_page.dart';
import 'package:djibly/pages/addresses/edit_address/edit_address_page.dart';
import 'package:djibly/pages/addresses/user_addresses_page.dart';
import 'package:djibly/pages/auth/auth_page.dart';
import 'package:djibly/pages/auth/verify_otp_page.dart';
import 'package:djibly/pages/cart/cart_page.dart';
import 'package:djibly/pages/make_order/delivery_address/select_address_page.dart';
import 'package:djibly/pages/make_order/make_order_page.dart';
import 'package:djibly/pages/order_details/order_details_page.dart';
import 'package:djibly/pages/orders_list/orders_list_page.dart';
import 'package:djibly/pages/pos/pos_page.dart';
import 'package:djibly/pages/product_details/product_details_page.dart';
import 'package:djibly/pages/products/products_list_page.dart';
import 'package:djibly/pages/profile/user_profile_page.dart';
import 'package:djibly/pages/register/register_page.dart';
import 'package:djibly/pages/search/search_page.dart';
import 'package:djibly/pages/slider/slider_page.dart';
import 'package:djibly/pages/splash/splash_page.dart';
import 'package:djibly/pages/welcome/welcome_page.dart';
import 'package:djibly/pages/wishlist/wishlist_page.dart';
import 'package:djibly/providers/auth_provider.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/authentication/presentation/bindings/auth_binding.dart';
import '../features/authentication/presentation/pages/login_page.dart';
import '../pages/home/home_page copy.dart';

final routes = {
  '/': (context) => Router(),
  // '/': (context) => CartPage(),
  WelcomePage.routeName: (BuildContext context) => WelcomePage(),
  SliderPage.routeName: (BuildContext context) => SliderPage(),

  // Auth Routes ---------------------------------------------------------------
  AuthPage.routeName: (BuildContext context) {
    AuthBinding().dependencies();
    return LoginPage();
  },
  VerifyOtpPage.routeName: (BuildContext context) => VerifyOtpPage(),
  RegisterPage.routeName: (BuildContext context) => RegisterPage(),
  // End Auth Routes -----------------------------------------------------------

  HomePage.routeName: (BuildContext context) => HomePage(),
  UserProfilePage.routeName: (BuildContext context) => UserProfilePage(),

  // Addresse Routes -----------------------------------------------------------
  UserAddressesPage.routeName: (BuildContext context) => UserAddressesPage(),
  AddAddressPage.routeName: (BuildContext context) => AddAddressPage(),
  EditAddressPage.routeName: (BuildContext context) => EditAddressPage(),
  // End Addresses Routes ------------------------------------------------------

  SearchPage.routeName: (BuildContext context) => SearchPage(),

  // Make Order Routes ---------------------------------------------------------
  CartPage.routeName: (BuildContext context) => CartPage(),
  MakeOrderPage.routeName: (BuildContext context) => MakeOrderPage(),
  SelectAddressWidget.routeName: (BuildContext context) =>
      SelectAddressWidget(),
  // End Make Order Routes -----------------------------------------------------

  PosPage.routeName: (BuildContext context) => PosPage(),
  ProductsListPage.routeName: (BuildContext context) => ProductsListPage(),
  ProductDetailsPage.routeName: (BuildContext context) => ProductDetailsPage(),
  OrdersListPage.routeName: (BuildContext context) => OrdersListPage(),
  OrderDetailsPage.routeName: (BuildContext context) => OrderDetailsPage(),
  WishlistPage.routeName: (BuildContext context) => WishlistPage(),
};

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              switch (authProvider.status) {
                case Status.Uninitialized:
                  return SplashScreen();
                case Status.Unauthenticated:
                  return AuthPage();
                case Status.Unverified:
                  return VerifyOtpPage();
                case Status.Unregistered:
                  return RegisterPage();
                default:
                  return HomePage();
              }
            },
          ),
        ),
      ),
    );
  }
}

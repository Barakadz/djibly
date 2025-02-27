import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/order.dart';
import 'package:djibly/pages/cart/cart_page.dart';
import 'package:djibly/presenters/order_presenter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:djibly/pages/cart/badge.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class CommonStyles {
  static textFormFieldStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Color(0xFFF2F2F2),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
    );
  }

  static noBorderTextFormFieldStyle(String hint, Color color) {
    return InputDecoration(
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      fillColor: color,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: color),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: color),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: color),
      ),
    );
  }

  static shoppingCartAppBar(context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 65.0,
      elevation: 0.4,
      title: Consumer<CartPresenter>(builder: (_, cartProvider, ch) {
        return Center(
          child: Text(
            AppLocalizations.of(MyApp.navigatorKey.currentContext).my_cart +
                ' ${cartProvider.getNumberOfItems() > 0 ? '(${cartProvider.getNumberOfItems().toString()})' : ''}',
          ),
        );
      }),
      leading: !CartPage.showReturn
          ? SizedBox(width: 0.0, height: 0.0)
          : IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: InkWell(
            onTap: () async {
              if (Provider.of<CartPresenter>(context, listen: false)
                      .getSelectedItems()
                      .length >
                  0) {
                Loader.show(
                  context,
                  progressIndicator: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.black),
                    strokeWidth: 2.0,
                  ),
                );
                await Provider.of<CartPresenter>(context, listen: false)
                    .deleteSelectedItems();
                Loader.hide();
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.red.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Iconsax.trash,
                  color: Colors.red.shade600,
                  size: 17,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static customAppBar(context, title, {showCart = true}) {
    return AppBar(
      centerTitle: false,
      title: Text(
        '' + title,
      ),
      leading: InkWell(
        child: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 30.0,
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        showCart
            ? Consumer<CartPresenter>(builder: (_, cartProvider, ch) {
                return CartBadge(
                  value: cartProvider.getNumberOfItems() > 0
                      ? cartProvider.getNumberOfItems().toString()
                      : null,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    icon:
                        Icon(Icons.shopping_cart_outlined, color: Colors.black),
                  ),
                );
              })
            : Container(),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Icon(
        //     Icons.notifications_outlined,
        //     color: Colors.black,
        //     size: 30.0,
        //   ),
        // ),
      ],
    );
  }

  static orderDetailsAppBar(context, title, Function onSelectedFunction) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        '${title}',
      ),
      leading: InkWell(
        child: Icon(
          FeatherIcons.chevronLeft,
          color: Colors.black,
          size: 18.0,
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: false,
      actions: [
        Container(child: Consumer<OrderPresenter>(
          builder: (context, orderPresenter, child) {
            return (orderPresenter.selectedOrder.lastState ==
                        Order.STATUS_PENDING ||
                    orderPresenter.selectedOrder.lastState ==
                        Order.STATUS_VALIDATED ||
                    orderPresenter.selectedOrder.lastState ==
                        Order.STATUS_DELIVERING)
                ? PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onSelected: onSelectedFunction,
                    itemBuilder: (BuildContext context) {
                      return {
                        context.translate.cancel_text,
                      }.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  )
                : Container();
          },
        ))
      ],
    );
  }

  static Widget errorConnectionWidget(context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.8 * 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/internet-connection-error.png',
              width: MediaQuery.of(context).size.width * 0.8,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration inputDecoration(
      {hint = '', type = 'text', IconData icon = null}) {
    return InputDecoration(
      filled: true,
      contentPadding: const EdgeInsets.all(5),
      fillColor: Color(0xFFF2F2F2),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
      ),
      prefixIcon: Icon(
        icon,
        color: Color(0xFFe31D1A),
        size: 20.0,
      ),
    );
  }
}

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/pages/make_order/make_order_page.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class CartFooter extends StatefulWidget {
  @override
  _CartFooterState createState() => _CartFooterState();
}

class _CartFooterState extends State<CartFooter> {
  bool _checkAll;
  double _totalAmount = 0;
  static LatLng _myPosition;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _checkAll =
        Provider.of<CartPresenter>(context, listen: false).getCheckAllItems();
    return Consumer<CartPresenter>(builder: (_, cartProvider, ch) {
      return DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(
              color: Colors.grey.shade200,
            ))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              if (cartProvider.getSelectedItems().isEmpty)
                SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.orange)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, color: Colors.orange, size: 17),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                context.translate.select_cart_product_text,
                                style: context.textTheme.labelLarge.copyWith(
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              Row(
                children: [
                  /*     IconButton(
                      onPressed: () {
                        if (cartProvider.isAllItemsSelected()) {
                          cartProvider.deselectAllItems();
                        } else {
                          cartProvider.selectAllItems();
                        }
                      },
                      icon: cartProvider.isAllItemsSelected()
                          ? Icon(
                              Icons.checklist_rounded,
                              color: Colors.blue,
                            )
                          : Icon(Icons.checklist_sharp)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        AppLocalizations.of(MyApp.navigatorKey.currentContext)
                            .select_all),
                  ), */
                  Expanded(
                    child: Container(
                      child: CustomElevatedButton(
                        radius: 12,
                        buttonColor: context.colorScheme.primary,
                        onPressed: cartProvider.totalPrice() >= 0 &&
                                cartProvider.getSelectedItems().length > 0
                            ? () async {
                                Loader.show(
                                  context,
                                  progressIndicator: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.black,
                                    ),
                                    strokeWidth: 2.0,
                                  ),
                                );
                                // Position position = await _getCurrentLocation();
                                
                                // if (position != null) {
                                Map<String, dynamic> data = {};
                                await Provider.of<CreateOrderPresenter>(context,
                                        listen: false)
                                    .setOrderData(data);
                                Provider.of<CreateOrderPresenter>(context,
                                        listen: false)
                                    .setSelectedItems(
                                        cartProvider.getSelectedItems());
                                Navigator.of(context).pushNamed(
                                  MakeOrderPage.routeName,
                                );
                                // } else {
                                //   return null;
                                // }
                                Loader.hide();
                              }
                            : () async {},
                        child: cartProvider.totalPrice() >= 0 &&
                                cartProvider.getSelectedItems().length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      '${AppLocalizations.of(MyApp.navigatorKey.currentContext).to_order} ',
                                      style: context.text.titleLarge.copyWith(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      (cartProvider.totalPrice() +
                                              cartProvider.totalDeliveryPrice())
                                          .toDZD(),
                                      style: context.text.titleLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${AppLocalizations.of(MyApp.navigatorKey.currentContext).to_order} ',
                                  style: context.text.titleLarge.copyWith(
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _isLoading = false;
      });
      return position;
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      ToastService.showErrorToast(
          'Vous devez activer votre position pour obtenir votre position GPS');
      return null;
    });
    return position;
  }
}

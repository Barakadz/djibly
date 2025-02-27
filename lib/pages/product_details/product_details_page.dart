import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/product_details/bottom_sheet_color/bottom_sheet_color_widget.dart';
import 'package:djibly/pages/product_details/product_widget.dart';
import 'package:djibly/presenters/add_to_cart_presenter.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = 'product_details_page';

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool isLoading = false;

  bool _searched = false;

  // PosProduct _product;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    _searched = arguments['searched'];
    // _product = arguments['product'];
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductDetailsWidget(searched: _searched),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ProductDetailsPresenter>(
                  builder: (context, productDetailsPresenter, child) {
                return CustomElevatedButton(
                  radius: 12,
                  buttonColor: context.colorScheme.primary,
                  textColor: context.colorScheme.onPrimary,
                  isDisabled: false,
                  onPressed: () {
                    _addToCartModal(
                        productDetailsPresenter.selectedProduct, context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 20.0,
                          color: context.colorScheme.onPrimary,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          AppLocalizations.of(MyApp.navigatorKey.currentContext)
                              .add_to_cart,
                          style: context.text.titleLarge.copyWith(
                            color: context.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _addToCartModal(PosProduct product, context) {
    Provider.of<AddToCartPresenter>(context, listen: false).setProduct(product);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(0),
          child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: Colors.white),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: BottomSheetColorWidget(product: product),
                ),
              )),
        );
      },
    );
  }
}

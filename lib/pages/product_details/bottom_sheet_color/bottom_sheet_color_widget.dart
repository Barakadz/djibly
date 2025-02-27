import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/models/available_color.dart';
import 'package:djibly/models/color.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/cart/cart_page.dart';
import 'package:djibly/pages/product_details/bottom_sheet_color/bottom_sheet_color_item.dart';
import 'package:djibly/presenters/add_to_cart_presenter.dart';
import 'package:djibly/services/color_service.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/ui/components/buttons/rounded_elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:djibly/pages/cart/delivery_price_widget.dart';

class BottomSheetColorWidget extends StatefulWidget {
  final PosProduct product;

  BottomSheetColorWidget({Key key, this.product}) : super(key: key);

  @override
  State<BottomSheetColorWidget> createState() => _BottomSheetColorWidgetState();
}

class _BottomSheetColorWidgetState extends State<BottomSheetColorWidget> {
  AvailableColor _selectedColor;

  final _quantity = TextEditingController();

  @override
  void initState() {
    _quantity..text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddToCartPresenter>(
        builder: (context, addToProductPresenter, child) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Text(
                      context.translate.select_color_text,
                      style: context.text.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.start,
                            spacing: 0.0,
                            runSpacing: 5.0,
                            children: _getList(
                                addToProductPresenter.getAvailableColors()),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12),
                    child: Text(
                      context.translate.quantity_text,
                      style: context.text.titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 30, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context
                                            .translate.available_quantity_text,
                                        style: context.text.labelLarge.copyWith(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      if (_selectedColor != null)
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: _selectedColor != null
                                                  ? Colors.orange.shade50
                                                  : DjiblyColor),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                _selectedColor != null
                                                    ? _selectedColor.quantity
                                                        .toString()
                                                    : "Merci de sélectionner une couleur",
                                                style: TextStyle(
                                                    color:
                                                        _selectedColor != null
                                                            ? Colors.orange
                                                            : DjiblyColor),
                                              )),
                                        ),
                                      if (_selectedColor == null)
                                        Text(
                                          context.translate.select_color_text,
                                          style:
                                              context.text.labelLarge.copyWith(
                                            color: context.colorScheme.error,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              context.translate.quantity_text,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            width: 40,
                                            height: 40.0,
                                            child: IconButton(
                                                alignment: Alignment.center,
                                                color: Colors.white,
                                                icon: Icon(
                                                  FontAwesomeIcons.minus,
                                                  size: 15,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (int.parse(
                                                            _quantity.text) >
                                                        1)
                                                      _quantity.text =
                                                          "${int.parse(_quantity.text) - 1}";
                                                  });
                                                }),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 40,
                                            height: 40.0,
                                            color: Colors.grey[100],
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: _quantity,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              decoration: CommonStyles
                                                  .noBorderTextFormFieldStyle(
                                                      '', Colors.grey[100]),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  height: 2.9),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(4),
                                              ),
                                            ),
                                            width: 40,
                                            height: 40.0,
                                            child: IconButton(
                                                alignment: Alignment.center,
                                                color: Colors.white,
                                                icon: Icon(
                                                  FontAwesomeIcons.plus,
                                                  size: 15,
                                                  color: Colors.black54,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (int.parse(
                                                            _quantity.text) <
                                                        _selectedColor.quantity)
                                                      _quantity.text =
                                                          "${int.parse(_quantity.text) + 1}";
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                // "Sub Total",
                                context.translate.subtotal_price_text,
                                style: context.text.labelLarge.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (widget.product.price *
                                        int.parse(_quantity.text))
                                    .toDZD(),
                                style: context.text.labelLarge.copyWith(),
                              ),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: RichText(
                        //     textAlign: TextAlign.end,
                        //       text: TextSpan(
                        //         children: [
                        //           TextSpan(
                        //             text: "+ Frais de livraison ",
                        //             style: TextStyle(
                        //               color: LinksColor,
                        //               fontSize: 14.0
                        //             )
                        //           ),
                        //           TextSpan(
                        //             text: widget.product.deliveryPrice.toDZD(),
                        //               style: TextStyle(
                        //                   color: LinksColor,
                        //                   fontSize: 14.0,
                        //                 fontWeight: FontWeight.bold
                        //               )
                        //           ),
                        //         ],
                        //       ),
                        //     )
                        // )
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8),
                          child: DeliveryPriceWidget(
                              deliveryPrice: widget.product.deliveryPrice,
                              padding: 0.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.translate.total_price_text,
                                style: context.text.labelLarge.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                (widget.product.price *
                                            int.parse(_quantity.text) +
                                        widget.product.deliveryPrice)
                                    .toDZD(),
                                style: context.text.labelLarge.copyWith(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: CustomElevatedButton(
                        radius: 12,
                        isDisabled: false,
                        onPressed: () async {
                          if (_selectedColor != null) {
                            _addToCart();
                          } else {
                            ToastService.showErrorToast(
                                context.translate.select_color_error_text);
                          }
                        },
                        buttonColor: context.colorScheme.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart_outlined,
                              color: context.colorScheme.onPrimary,
                              size: 20,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              context.translate.add_to_cart,
                              style: context.text.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _getList(List<AvailableColor> data) {
    List<Widget> widgets = [];
    if (data != null && data.length > 0) {
      data.forEach((availableColor) {
        widgets.add(InkWell(
          onTap: () {
            setState(() {
              _selectedColor = availableColor;
              _quantity..text = "1";
            });
          },
          child: BottomSheetColorItem(
            isSelected: _selectedColor == availableColor,
            color: ColorService.fromHex(availableColor.color.hex),
          ),
        ));
      });
    }
    return widgets;
  }

  _addToCart() async {
    Loader.show(context,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.black),
          strokeWidth: 2.0,
        ));
    var _data = {
      "available_color_id": _selectedColor.id,
      "quantity": _quantity.text
    };

    bool response =
        await Provider.of<AddToCartPresenter>(context, listen: false)
            .addProductToCart(_data);
    Loader.hide();
    if (response) {
      Navigator.of(context).pop();

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    context.translate.add_product_successfully_text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle_outline_outlined,
                    color: context.colorScheme.onSurface,
                    size: 30,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    context.translate.add_product_cart_successfully_text,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomRoundedElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          buttonColor: DjiblyColor,
                          isDisabled: false,
                          child: Text(
                            context.translate.close_text,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomRoundedElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            CartPage.showReturn = true;
                            Navigator.of(context).pushNamed(CartPage.routeName);
                          },
                          buttonColor: DjiblyColor,
                          isDisabled: false,
                          child: Text(
                            context.translate.my_cart,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }
  }
}

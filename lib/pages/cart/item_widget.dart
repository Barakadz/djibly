import 'dart:io';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:djibly/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/color_service.dart';

class ItemWidget extends StatefulWidget {
  CartItem item;
  BuildContext context;

  ItemWidget({this.item, this.context});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  CartItem _item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _item = Provider.of<CartPresenter>(context, listen: false)
        .getItemFromId(widget.item.id);
    return Consumer<CartPresenter>(
      builder: (_, cartProvider, ch) => InkWell(
        onTap: () {
          if (cartProvider.isItemSelected(_item.id)) {
            Provider.of<CartPresenter>(context, listen: false)
                .deselectItem(_item.id);
          } else {
            Provider.of<CartPresenter>(context, listen: false)
                .selectItem(_item.id);
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: cartProvider.isItemSelected(_item.id)
                      ? Colors.blue
                      : Colors.white,
                  width: cartProvider.isItemSelected(_item.id) ? 2 : 0)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                    cartProvider.isItemSelected(_item.id)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: Colors.blue),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    width: 55,
                    height: 55,
                    imageUrl: Network.storagePath + _item.productImage,
                    httpHeaders: Network.headersWithBearer,
                    imageBuilder: (context, imageProvider) => Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return SizedBox(
                        height: 55,
                      );
                    },
                    placeholder: (context, url) {
                      return SizedBox(
                        height: 55,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        (_item.productBrand + " " + _item.productName)
                            .toTitleCase(),
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelLarge,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        (_item.productPrice * _item.quantity).toDZD(),
                        textAlign: TextAlign.end,
                        style: context.text.labelLarge.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      /*     SizedBox(
                        width: 20,
                        height: 20,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                          color: ColorService.fromHex(_item.color.hex),
                        )),
                      ) */
                    ],
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: _item.quantity == 1
                                    ? Colors.white54
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        FontAwesomeIcons.minus,
                                        size: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: _item.quantity == 1
                                        ? null
                                        : () async {
                                            Loader.show(context,
                                                progressIndicator:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.black),
                                                  strokeWidth: 2.0,
                                                ));
                                            await Provider.of<CartPresenter>(
                                                    context,
                                                    listen: false)
                                                .decreaseQuantity(_item.id);
                                            Loader.hide();
                                            if (_item.quantity > 1) {}
                                          }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                _item.quantity.toString(),
                                style: context.text.labelMedium,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: _item.quantity >= _item.availableQuantity
                                    ? Colors.grey[200]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50)),
                                child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        FontAwesomeIcons.plus,
                                        size: 10,
                                        color: Colors.black,
                                      ),
                                    ),
                                    onTap: _item.quantity >=
                                            _item.availableQuantity
                                        ? null
                                        : () async {
                                            Loader.show(context,
                                                progressIndicator:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.black),
                                                  strokeWidth: 2.0,
                                                ));
                                            await Provider.of<CartPresenter>(
                                                    context,
                                                    listen: false)
                                                .increaseQuantity(_item.id);
                                            Loader.hide();
                                          }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

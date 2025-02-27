import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:flutter/material.dart';
import 'package:djibly/models/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  CartItem item;
  BuildContext context;

  ProductWidget({this.item, this.context});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 120.0,
          width: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60), color: Colors.white),
          child: GestureDetector(
            onTap: () {},
            child: CachedNetworkImage(
              imageUrl: Network.storagePath + widget.item.productImage,
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
                  height: 120.0,
                );
              },
              placeholder: (context, url) {
                return SizedBox(
                  height: 120.0,
                );
              },
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    (widget.item.productBrand + ' ' + widget.item.productName)
                        .toTitleCase(),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelLarge.copyWith(),
                  ),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    context.translate.quantity_text,
                    style: context.text.labelLarge.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    widget.item.quantity.toString(),
                    textAlign: TextAlign.end,
                    style: context.text.labelLarge.copyWith(),
                  )),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    context.translate.product_price_text,
                    style: context.text.labelLarge.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    widget.item.productPrice.toDZD(),
                    textAlign: TextAlign.end,
                    style: context.text.labelLarge.copyWith(),
                  )),
                ],
              ),
            ),
            Divider()
          ],
        ),
      ],
    );
  }
}

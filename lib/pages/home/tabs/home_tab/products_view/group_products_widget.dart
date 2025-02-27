import 'package:djibly/app/core/extensions/list_extension.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/ads.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/ad_banner_widget.dart';
import 'package:djibly/pages/products/product_widget.dart';
import 'package:flutter/material.dart';

class GroupProductsWidget extends StatefulWidget {
  Map<String, List<PosProduct>> products;
  Ads ad;

  GroupProductsWidget({Key key, this.products, this.ad}) : super(key: key);

  @override
  State<GroupProductsWidget> createState() => _GroupProductsWidgetState();
}

class _GroupProductsWidgetState extends State<GroupProductsWidget> {
  @override
  Widget build(BuildContext context) {
    List<PosProduct> posProducts =
        widget.products.values.expand((list) => list).toList();
    String title = widget.products.keys.first;

    return widget.products != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Text(
                  '$title',
                  textAlign: TextAlign.start,
                  style: context.text.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8),
                    ...posProducts.map((e) => ProductWidget(product: e))
                  ].addSeparators(
                    SizedBox(
                      width: 12,
                    ),
                  ),
                ),
              ),
              /*  SizedBox(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: posProducts.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return ProductWidget(
                          product:
                              posProducts[(posProducts.length - 1) - index]);
                    }),
              ), */
              widget.ad != null
                  ? AdBannerWidget(
                      ad: widget.ad,
                    )
                  : Container()
            ],
          )
        : Container();
  }
}

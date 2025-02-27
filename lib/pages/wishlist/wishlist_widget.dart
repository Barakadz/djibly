import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/wishlist/wishlist_item_widget.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class WishlistWidget extends StatefulWidget {
  List<PosProduct> products;

  WishlistWidget({Key key, this.products}) : super(key: key);

  @override
  State<WishlistWidget> createState() => _WishlistWidgetState();
}

class _WishlistWidgetState extends State<WishlistWidget> {
  bool loadingMore = false;

  @override
  Widget build(BuildContext context) {
    return widget.products.isEmpty
        ? SizedBox(
            height: 500,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.data_array_sharp, size: 50),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    context.translate.empty_list_text,
                  )
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(2.5),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.800,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return WishlistItemWidget(product: widget.products[index]);
              },
            ),
          );
  }
}

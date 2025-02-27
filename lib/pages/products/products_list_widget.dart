import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/products/product_widget.dart';
import 'package:djibly/presenters/pos_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProductsListWidget extends StatefulWidget {
  List<PosProduct> products;
  final ScrollController controller;

  ProductsListWidget({Key key, this.products, this.controller})
      : super(key: key);

  @override
  State<ProductsListWidget> createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  bool loadingMore = false;

  @override
  Widget build(BuildContext context) {
/* 
    return AlignedGridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      itemCount: products.length,
      crossAxisSpacing: 8,
      itemBuilder: (context, index) {
        return ProductWidget(product: products[index]);
      },
    ); */
    return GridView.builder(
      controller: widget.controller != null ? widget.controller : null,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return ProductWidget(
          product: widget.products[index],
        );
      },
    );
  }
}

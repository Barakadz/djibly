import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSpecificationWidget extends StatelessWidget {
  final List<Map<String, dynamic>> specifications;
  ProductSpecificationWidget({this.specifications});
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsPresenter>(
        builder: (context, productDetailsPresenter, child) {
      print(productDetailsPresenter.selectedProduct.id);
      return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            productDetailsPresenter.selectedProduct.specifications.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productDetailsPresenter.selectedProduct.specifications[index]
                      ['specification'],
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelLarge.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    productDetailsPresenter
                        .selectedProduct.specifications[index]['value'],
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: context.text.labelLarge.copyWith(),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      );
    });
  }
}

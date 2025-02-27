import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/products/products_list_widget.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';

class ProductsListPage extends StatelessWidget {
  static const String routeName = 'products_list_page';
  String category;
  String categoryName;
  String posId;

  ProductsListPage({this.category, this.categoryName, this.posId});

  bool _isLoading = false;

  // double deleteButtonWidth = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonStyles.customAppBar(context, categoryName.toUpperCase()),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            child: FutureBuilder<List<PosProduct>>(
                future: PosProduct.getPosProductsFromUuid(category,posId),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      {
                        return Center(
                          child: SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              strokeWidth: 2.0,
                            ),
                          ),
                        );
                      }
                    default:
                      {
                        if (snapshot.hasError) {
                          return CommonStyles.errorConnectionWidget(context);
                        } else {
                          return ProductsListWidget(products: snapshot.data);
                        }
                      }
                  }
                }),
          ),
        ),
      ),
    );
  }
}

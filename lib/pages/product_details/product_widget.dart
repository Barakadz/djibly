import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/pages/pos/pos_page.dart';
import 'package:djibly/pages/product_details/product_reviews_widget.dart';
import 'package:djibly/pages/product_details/product_specifications_widget.dart';
import 'package:djibly/pages/product_details/product_tab_widget.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class ProductDetailsWidget extends StatefulWidget {
  // final PosProduct product;
  final bool searched;

  ProductDetailsWidget({this.searched});

  @override
  _ProductDetailsWidgetState createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailsPresenter>(
        builder: (context, productDetailsPresenter, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      productDetailsPresenter.selectedProduct.brand +
                          " " +
                          productDetailsPresenter.selectedProduct.name,
                      style: context.text.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  productDetailsPresenter.selectedProduct != null
                      ? InkWell(
                          onTap: () {
                            if (!productDetailsPresenter.isLoading) {
                              if (productDetailsPresenter
                                  .selectedProduct.inWishlist)
                                productDetailsPresenter.removeFromWishlist();
                              else
                                productDetailsPresenter.addToWishlist();
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: productDetailsPresenter.getWishlistIcon(),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: CachedNetworkImage(
                      imageUrl: Network.storagePath +
                          productDetailsPresenter.selectedProduct.picture,
                      httpHeaders: Network.headersWithBearer,
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.translate.model_text,
                              style: context.text.labelLarge.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                (productDetailsPresenter.selectedProduct.brand +
                                        ' ' +
                                        productDetailsPresenter
                                            .selectedProduct.name)
                                    .toTitleCase(),
                                style: context.text.labelLarge.copyWith(),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.translate.product_price_text,
                              style: context.text.labelLarge.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              productDetailsPresenter.selectedProduct.price
                                      .toStringAsFixed(0) +
                                  ' ${context.translate.dz_money}',
                              style: context.text.labelLarge.copyWith(),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'POS',
                              style: context.text.labelLarge.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.searched) {
                                  Navigator.of(context)
                                      .pushNamed(PosPage.routeName, arguments: {
                                    'name': productDetailsPresenter
                                        .selectedProduct.pos,
                                    'id': productDetailsPresenter
                                        .selectedProduct.posId
                                  });
                                } else {
                                  Navigator.popUntil(context,
                                      ModalRoute.withName(PosPage.routeName));
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    productDetailsPresenter.selectedProduct.pos
                                        .toTitleCase(),
                                    style: context.text.labelLarge.copyWith(
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Review'),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          "${productDetailsPresenter.selectedProduct.avgReviews.toStringAsFixed(1)} ",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF878787))),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*    Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text("Released Date"),
                            Text(
                                "${productDetailsPresenter.selectedProduct.released}")
                          ],
                        ),
                      ) */
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              context.translate.specifications,
              style: context.text.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Consumer<ProductDetailsPresenter>(
                  builder: (context, productDetailsPresenter, child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductTabWidget(
                            backgroundColor: productDetailsPresenter
                                        .getSelectedView() ==
                                    ProductDetailsPresenter.SPECIFICATION_VIEW
                                ? Colors.black
                                : Colors.white,
                            action: () {
                              if (productDetailsPresenter.getSelectedView() !=
                                  ProductDetailsPresenter.SPECIFICATION_VIEW)
                                Provider.of<ProductDetailsPresenter>(context,
                                        listen: false)
                                    .setSelectedView(ProductDetailsPresenter
                                        .SPECIFICATION_VIEW);
                            },
                            textColor: productDetailsPresenter
                                        .getSelectedView() ==
                                    ProductDetailsPresenter.SPECIFICATION_VIEW
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: ProductTabWidget(
                        //     backgroundColor:
                        //         productDetailsPresenter.getSelectedView() ==
                        //                 ProductDetailsPresenter.REVIEWS_VIEW
                        //             ? Colors.black
                        //             : Colors.white,
                        //     action: () {
                        //       if (productDetailsPresenter.getSelectedView() !=
                        //           ProductDetailsPresenter.REVIEWS_VIEW)
                        //         Provider.of<ProductDetailsPresenter>(context,
                        //                 listen: false)
                        //             .setSelectedView(
                        //                 ProductDetailsPresenter.REVIEWS_VIEW);
                        //     },
                        //     textColor: productDetailsPresenter.getSelectedView() ==
                        //             ProductDetailsPresenter.REVIEWS_VIEW
                        //         ? Colors.white
                        //         : Colors.black,
                        //     title: "Réviews",
                        //   ),
                        // ),
                      ],
                    ),
                    productDetailsPresenter.getSelectedView() ==
                            ProductDetailsPresenter.REVIEWS_VIEW
                        ? ProductReviewsWidget()
                        : ProductSpecificationWidget(
                            specifications: productDetailsPresenter
                                .selectedProduct.specifications,
                          )
                  ],
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}

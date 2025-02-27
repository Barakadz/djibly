import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/product_details/product_details_page.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  PosProduct product;
  ProductWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadiusDirectional.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Provider.of<ProductDetailsPresenter>(context, listen: false)
                      .setSelectedProduct(product);
                  Navigator.of(context).pushNamed(ProductDetailsPage.routeName,
                      arguments: {'product': product, 'searched': true});
                },
                child: Center(
                  child: CachedNetworkImage(
                    height: 132,
                    imageUrl: Network.storagePath + product.picture,
                    httpHeaders: Network.headersWithBearer,
                    imageBuilder: (context, imageProvider) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        width: 100,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Provider.of<ProductDetailsPresenter>(context,
                                    listen: false)
                                .setSelectedProduct(product);
                            Navigator.of(context).pushNamed(
                                ProductDetailsPage.routeName,
                                arguments: {
                                  'product': product,
                                  'searched': true
                                });
                          },
                          child: SizedBox(
                            width: 100,
                            height: 140,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          height: 140,
                          child: Image.asset(
                            "assets/images/carousel_placeholder.png",
                            height: 140,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Text(
                product.brand + ' ' + product.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: context.text.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      product.price.toStringAsFixed(0) +
                          ' ${context.translate.dz_money}',
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        product.avgReviews <= 1
                            ? Icons.star_border
                            : Icons.star,
                        size: 18,
                        color: Colors.orange.shade200,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        product.avgReviews.toString(),
                        style: context.text.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
    /*  return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<ProductDetailsPresenter>(context,
                              listen: false)
                          .setSelectedProduct(product);
                      Navigator.of(context).pushNamed(
                          ProductDetailsPage.routeName,
                          arguments: {'product': product, 'searched': true});
                    },
                    child: CachedNetworkImage(
                      imageUrl: Network.storagePath + product.picture,
                      httpHeaders: Network.headersWithBearer,
                      imageBuilder: (context, imageProvider) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Provider.of<ProductDetailsPresenter>(context,
                                      listen: false)
                                  .setSelectedProduct(product);
                              Navigator.of(context).pushNamed(
                                  ProductDetailsPage.routeName,
                                  arguments: {
                                    'product': product,
                                    'searched': true
                                  });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 140,
                            ),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 100,
                            height: 140,
                            child: Image.asset(
                              "assets/images/carousel_placeholder.png",
                              height: 140,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.brand + ' ' + product.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar.builder(
                      initialRating: product.avgReviews,
                      itemSize: 12,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      product.price.toStringAsFixed(0) + ' DZD',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); */
  }
}

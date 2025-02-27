import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/models/pos_product.dart';
import 'package:djibly/pages/product_details/product_details_page.dart';
import 'package:djibly/presenters/product_details_presenter.dart';
import 'package:djibly/presenters/wishlist_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class WishlistItemWidget extends StatelessWidget {
  PosProduct product;

  WishlistItemWidget({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  border: Border.all(color: Color(0xFFCCCCCC))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<ProductDetailsPresenter>(context,
                              listen: false)
                          .setSelectedProduct(product);
                      Navigator.of(context).pushNamed(
                          ProductDetailsPage.routeName,
                          arguments: {'product': product, 'searched': false});
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
                      errorWidget: (context, url, error){
                        return SizedBox(
                          width: 100.0,
                          height: 140.0,
                        );
                      },

                      placeholder: (context, url){
                        return SizedBox(
                          width: 100.0,
                          height: 140.0,
                        );
                      },
                    ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 10.0),
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
                          product.price.toDZD(),
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
          Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  Provider.of<WishlistPresenter>(context, listen: false).setSelectedProduct(product);
                  Provider.of<WishlistPresenter>(context, listen: false).removeFromWishlist();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Provider.of<WishlistPresenter>(context, listen: false)
                      .getWishlistIcon(product.id),
                ),
              )),
        ],
      ),
    );
  }
}

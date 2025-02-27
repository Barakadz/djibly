import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/models/order.dart';
import 'package:djibly/models/order_item.dart';
import 'package:djibly/pages/orders_list/order_widgets/review_widget.dart';
import 'package:djibly/presenters/order_presenter.dart';
import 'package:djibly/services/http_services/api_http.dart';
import 'package:djibly/services/color_service.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderItemWidget extends StatefulWidget {
  OrderItem item;
  String state;

  OrderItemWidget({this.item, this.state});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: Network.storagePath + widget.item.productPicture,
            httpHeaders: Network.headersWithBearer,
            imageBuilder: (context, imageProvider) => Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                width: 120.0,
                height: 120.0,
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
                width: 120.0,
              );
            },
            placeholder: (context, url) {
              return SizedBox(
                height: 120.0,
                width: 120.0,
              );
            },
          ),
          // child: Image.network(
          //   Network.host + widget.item.productPicture,
          //   width: MediaQuery.of(context).size.width * 0.2,
          // ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    widget.item.productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context).product_price_text + ": "  + widget.item.productPrice.toDZD(),
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: AppLocalizations.of(context).color_text + ": ",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0)),
                        WidgetSpan(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  ColorService.fromHex(widget.item.color.hex),
                              border: Border.all(
                                color: Colors.black45,
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                            ),
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context).total_price_text + ": " + widget.item.totalPrice.toDZD(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                ),
                widget.state == Order.STATUS_FINISHED ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).rating_text + ": ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                      widget.item.review != null
                          ? RatingBarIndicator(
                              rating: double.parse(
                                  widget.item.review.review.toString()),
                              itemCount: 5,
                              itemSize: 20.0,
                              itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ))
                          : Expanded(
                            child: InkWell(
                                onTap: () {
                                  showRatingDialog(context, widget.item.id);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(
                                    AppLocalizations.of(context).evaluate_product_text,
                                    style: TextStyle(
                                        fontSize: 14.0, color: LinksColor),
                                  ),
                                ),
                              ),
                          )
                    ],
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  showRatingDialog(context, int orderItemID) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ReviewWidget(orderItemID: orderItemID);
      },
    );
  }
}

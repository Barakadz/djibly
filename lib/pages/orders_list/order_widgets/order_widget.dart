import 'package:cached_network_image/cached_network_image.dart';
import '../../../app/core/extensions/theme_eextensions.dart';
import '../../../helpers/string_helper.dart';
import '../../../models/order.dart';
import '../../../services/http_services/api_http.dart';
import 'order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderWidget extends StatefulWidget {
  Order order;

  OrderWidget({this.order});
  @override
  _OrderWidgetState createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CachedNetworkImage(
                          imageUrl: Network.storagePath +
                              widget.order.items.last.productPicture,
                          httpHeaders: Network.headersWithBearer,
                          // imageUrl: "https://djibly-dev.otalgerie.com/djibly/"+widget.order.items.last.productPicture,
                          // imageUrl:
                          // "https://www.apple.com/newsroom/images/2023/09/apple-debuts-iphone-15-and-iphone-15-plus/article/Apple-iPhone-15-lineup-hero-geo-230912_inline.jpg.large.jpg",

                          width: 45,
                          errorWidget: (context, url, error) {
                            print("error");
                            print(error);
                            print(url);
                            return SizedBox(
                                width: 45,
                                height: 45,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(Icons.broken_image_outlined),
                                ));
                          }),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              context.translate.number_text +
                                  ' ${widget.order.id.toString()}',
                              style: context.text.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '(${getTotalProduct(widget.order)} ${getTotalProduct(widget.order) == 1 ? context.translate.items_text : context.translate.items_text} )',
                              style: context.text.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${widget.order.orderDate.toDateTimeFormat()}',
                                style: context.text.labelMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600),
                              ),
                              Text(
                                ' | ',
                                style: context.text.labelMedium.copyWith(),
                              ),
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '${widget.order.totalPrice.toDZD()}',
                                style: context.text.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: context.colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4,
                                ),
                                child: Row(
                                  children: [
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Order.orderStatusColor(
                                            widget.order.lastState),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: SizedBox(width: 10, height: 10),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      Order.orderStatusMessage(
                                          widget.order.lastState),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              /*     Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Color(0XFFD9D9D9)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context).order_text +
                                    ": ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black54),
                              ),
                              TextSpan(
                                text: widget.order.id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        color: Order.orderStatusColor(widget.order.lastState),
                        elevation: 1.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8.0),
                          child: Text(
                            Order.orderStatusMessage(widget.order.lastState),
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            AppLocalizations.of(context).order_date_text + ": ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black54),
                      ),
                      TextSpan(
                        text: widget.order.orderDate.toDateTimeFormat(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.order.items.length,
                  itemBuilder: (BuildContext itemCtxt, int itemIndex) {
                    return OrderItemWidget(
                        item: widget.order.items[itemIndex],
                        state: widget.order.lastState);
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                AppLocalizations.of(context).product_price_text,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500]),
                              ),
                            ),
                            Text(
                              widget.order.totalPrice.toDZD(),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context).quantity_text,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[500]),
                            ),
                          ),
                          Text(
                            getTotalProduct(widget.order),
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 45,
                alignment: Alignment.center,
                color: Colors.black,
                child: Text(
                  AppLocalizations.of(context).details_text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              )
         */
            ],
          ),
        ),
      ),
    );
  }

  int getTotalProduct(Order order) {
    int quantity = 0;
    order.items.forEach((item) {
      quantity += item.productQuantity;
    });
    return quantity;
  }
}

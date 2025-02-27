import 'package:cached_network_image/cached_network_image.dart';
import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/app/features/pos/presentation/controllers/pos_list_controller.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/models/pos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../services/http_services/api_http.dart';
import '../../../../pos/pos_page.dart';

class POSItemWidget extends StatelessWidget {
  final Pos pos;

  const POSItemWidget({Key key, this.pos}) : super(key: key);

  Widget build(BuildContext context) {
    POSListController controller = Get.find();
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(PosPage.routeName,
            arguments: {'name': pos.name, 'id': pos.id});
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade100,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                        imageUrl: Network.storagePath + pos.picture,
                        httpHeaders: Network.headersWithBearer,
                        // imageUrl: "https://djibly-dev.otalgerie.com/djibly/"+widget.order.items.last.productPicture,
                        // imageUrl:
                        // "https://www.apple.com/newsroom/images/2023/09/apple-debuts-iphone-15-and-iphone-15-plus/article/Apple-iPhone-15-lineup-hero-geo-230912_inline.jpg.large.jpg",
                        height: 140,
                        width: 100,
                        fit: BoxFit.cover,
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
                                child: Icon(
                                  Icons.broken_image_outlined,
                                ),
                              ));
                        }),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                pos.name,
                                style: context.text.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            children: [
                              Text(
                                pos.address,
                                style: context.text.labelMedium.copyWith(
                                    color: Colors.grey.shade500,
                                    height: 1.8,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade100)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.translate.delivery_price_text,
                                      style: context.text.labelMedium.copyWith(
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      double.tryParse(pos.deliveryPrice)
                                          .toDZD(),
                                      style: context.text.labelMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.maxFinite,
                child: GestureDetector(
                  onTap: () => controller.openGoogleMaps(
                    double.tryParse(pos.lat),
                    double.tryParse(pos.lon),
                  ), // S
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              size: 18,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              context.translate.open_map,
                              style: context.text.labelLarge,
                            ),
                          ],
                        )),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

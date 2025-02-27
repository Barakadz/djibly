import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons/feather_icons.dart';

import '../../app/core/extensions/theme_eextensions.dart';
import '../../helpers/string_helper.dart';
import '../../models/order.dart';
import '../../services/color_service.dart';
import '../../services/http_services/api_http.dart';
import 'order_informations_widget.dart';
import 'tracking_widget.dart';
import '../orders_list/order_widgets/order_item_widget.dart';
import '../orders_list/order_widgets/order_status_widget.dart';
import '../../presenters/order_presenter.dart';
import '../../utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsWidget extends StatefulWidget {
  @override
  OrderDetailsWidgetState createState() => OrderDetailsWidgetState();
}

class OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderPresenter>(
      builder: (_, orderPresenter, ch) {
        return SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 16),
                child: Text(
                  context.translate.order_info_text,
                  style: context.text.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.translate.number_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              orderPresenter.selectedOrder.id.toString(),
                              style: context.text.labelLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).status_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
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
                                            orderPresenter
                                                .selectedOrder.lastState),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: SizedBox(width: 10, height: 10),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      Order.orderStatusMessage(orderPresenter
                                          .selectedOrder.lastState),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.translate.order_date_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              orderPresenter.selectedOrder.orderDate
                                  .toDateTimeFormat(),
                              style: context.text.labelLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.translate.costumer_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              orderPresenter.selectedOrder.firstName +
                                  " " +
                                  orderPresenter.selectedOrder.lastName,
                              style: context.text.labelLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      ExpansionTile(
                        title: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            context.translate.costumer_detail_text
                                .toTitleCase(),
                            style: context.text.labelLarge.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        children: [
                          DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: OrderInformationWidget()),
                        ],
                        collapsedTextColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  '${context.translate.order_summary_text} (${orderPresenter.selectedOrder.items.length} ${context.translate.items_text})',
                  style: context.text.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...orderPresenter.selectedOrder.items.map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 8),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: Network.storagePath +
                                          e.productPicture,
                                      httpHeaders: Network.headersWithBearer,
                                      // imageUrl:
                                      //     "https://www.apple.com/newsroom/images/2023/09/apple-debuts-iphone-15-and-iphone-15-plus/article/Apple-iPhone-15-lineup-hero-geo-230912_inline.jpg.large.jpg",
                                      height: 120,
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: Colors.red.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    border: Border.all(
                                                      color: Colors.red,
                                                    )),
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  color: Colors.red,
                                                ),
                                              )),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Divider(),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                context.translate.model_text,
                                                style: context.text.labelMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  e.productName,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: context
                                                      .text.labelMedium
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                context.translate.quantity_text,
                                                style: context.text.labelMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              Text(
                                                e.productQuantity.toString(),
                                                textAlign: TextAlign.center,
                                                style: context.text.labelMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 8,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                context.translate.color_text,
                                                style: context.text.labelMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              DecoratedBox(
                                                decoration: BoxDecoration(
                                                    color: ColorService.fromHex(
                                                        e.color.hex),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Row(
                                      children: [],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  context.translate.payement_info_text,
                  style: context.text.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.translate.product_price_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              orderPresenter.selectedOrder.productsPrice
                                      .toStringAsFixed(0) +
                                  ' ${context.translate.dz_money}',
                              style: context.text.labelLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                context.translate.delivery_price_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(height: 16),
                            Text(
                              double.tryParse(orderPresenter
                                          .selectedOrder.deliveryPrice)
                                      .toStringAsFixed(0) +
                                  ' ${context.translate.dz_money}',
                              style: context.text.labelLarge,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context).total_price_text,
                                style: context.text.labelLarge
                                    .copyWith(color: Colors.grey.shade600),
                              ),
                            ),
                            Text(
                              orderPresenter.selectedOrder.totalPrice
                                      .toStringAsFixed(0) +
                                  ' ${context.translate.dz_money}',
                              style: context.text.labelLarge.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  context.translate.tracking_info_text,
                  style: context.text.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Column(
                  children: [
                    TrackingWidget(),
                    /*    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFD9D9D9))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  orderPresenter.selectedOrder.pos,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Divider(
                              color: Color(0xFFD9D9D9),
                              thickness: 1.0,
                            ),
                            ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    orderPresenter.selectedOrder.items.length,
                                itemBuilder:
                                    (BuildContext itemCtxt, int itemIndex) {
                                  return OrderItemWidget(
                                      item: orderPresenter
                                          .selectedOrder.items[itemIndex]);
                                }),
                          ],
                        ),
                      ),
                    ), */
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderStatusWidget(String status) {
    switch (status) {
      case Order.STATUS_FINISHED:
        return OrderStatusWidget(
          state: 'Cette commande est terminée',
          color: Colors.lightGreen,
        );
      case Order.STATUS_DELIVERING:
        return OrderStatusWidget(
            state: 'Cette commande est en cour de livraison',
            color: Colors.orangeAccent);
      case Order.STATUS_CANCELED_BY_CLIENT:
      case Order.STATUS_CANCELED_BY_SELLER:
        return OrderStatusWidget(
            state: 'Cette commande est annulée', color: Colors.redAccent);
      case Order.STATUS_VALIDATED:
        return OrderStatusWidget(
            state: 'Cette commande est confirmée', color: Colors.blueAccent);
      default:
        return OrderStatusWidget(
            state: 'Cette commande est en attente de confirmation',
            color: Colors.yellow);
    }
  }
}

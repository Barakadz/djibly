import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/presenters/order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderInformationWidget extends StatelessWidget {
  const OrderInformationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderPresenter>(builder: (context, orderPresenter, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.order_number_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        orderPresenter.selectedOrder.id.toString(),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.order_date_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Text(
                        orderPresenter.selectedOrder.orderDate
                            .toDateTimeFormat(),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.phone_number_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        "${orderPresenter.selectedOrder.phone}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey.shade400,
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.full_name_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        "${orderPresenter.selectedOrder.firstName}  ${orderPresenter.selectedOrder.lastName}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      context.translate.address_text,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Text(
                          "${orderPresenter.selectedOrder.deliveryAddress}",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 15.0),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.payment_type_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        "${orderPresenter.selectedOrder.paymentType}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  color: Colors.grey.shade400,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          context.translate.delivery_type_text,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 2.0),
                      child: Text(
                        "${orderPresenter.selectedOrder.deliveryType}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

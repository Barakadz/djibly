import 'package:djibly/pages/make_order/delivery_type/product_widget.dart';
import 'package:djibly/pages/make_order/delivery_type/selected_delivery_price_widget.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:djibly/pages/cart/delivery_price_widget.dart';

class OrderedProductsWidget extends StatefulWidget {
  const OrderedProductsWidget({Key key}) : super(key: key);

  @override
  _OrderedProductsWidgetState createState() => _OrderedProductsWidgetState();
}

class _OrderedProductsWidgetState extends State<OrderedProductsWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderPresenter>(builder: (_, createOrder, ch) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: createOrder.getPosList().length,
            itemBuilder: (BuildContext ctxt, int index) {
              print(createOrder.getPosList().length);
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                      /*   bottom: BorderSide(
                      color: Colors.grey,
                    ), */
                      ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          createOrder.getPosList()[index].name,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF5A5A5A),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        color: Color(0xFFD9D9D9),
                        thickness: .0,
                        height: 0,
                      ),
                      ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              createOrder.getPosList()[index].items.length,
                          itemBuilder: (BuildContext itemCtxt, int itemIndex) {
                            return ProductWidget(
                              item: createOrder
                                  .getPosList()[index]
                                  .items[itemIndex],
                              context: context,
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DeliveryPriceWidget(
                            deliveryPrice:
                                createOrder.getPosList()[index].deliveryPrice,
                            padding: 5.0),
                      )
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }
}

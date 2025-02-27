import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/pages/make_order/make_order_page.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentWidget extends StatefulWidget {
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  int _paymentMethod = 1;
  final _deliveryPrice = 300;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('payment widget');
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'choisissez une méthode de paiement'.toUpperCase(),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Paiement à la livraison'.toUpperCase()),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                                '- Le paiement se fera directement auprés du préstataire de livraison.'),
                            Text(
                                '- En espéce, soyez certain d\'avoir le montant exact du paiement. Nos livreurs ne son pas munis monnaie.'),
                          ],
                        ),
                      ),
                      leading: Radio(
                        activeColor: Color(0xFFe31D1A),
                        value: 1,
                        groupValue: _paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _paymentMethod = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text('carte edahabia'.toUpperCase())),
                          Image.asset(
                            'assets/images/payments/eldahabia.png',
                            height: 80.0,
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      leading: Radio(
                        activeColor: Color(0xFFe31D1A),
                        value: 2,
                        groupValue: _paymentMethod,
                        onChanged: null,
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text('carte cib'.toUpperCase())),
                          Image.asset(
                            'assets/images/payments/cib.png',
                            height: 80.0,
                          )
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                      ),
                      leading: Radio(
                        activeColor: Color(0xFFe31D1A),
                        value: 3,
                        groupValue: _paymentMethod,
                        onChanged: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Consumer<CreateOrderPresenter>(
            builder: (_, orderProvider, ch) => Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Sout-total',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Text(
                            orderProvider.totalPrice().toStringAsFixed(2) +
                                ' DZD',
                            style: TextStyle(fontSize: 16.0),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Livraison',
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Text(
                            _deliveryPrice.toStringAsFixed(2) + ' DZD',
                            style: TextStyle(
                                fontSize: 16.0, color: Color(0xFFe31D1A)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            (orderProvider.totalPrice() + _deliveryPrice)
                                    .toStringAsFixed(2) +
                                ' DZD',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFe31D1A)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // widget.parent.setState(() {
                                    //   widget.parent.selectedTab = 0;
                                    //   widget.parent.tabController.index =
                                    //       widget.parent.selectedTab;
                                    // });
                                  },
                                  // color: Colors.orange,
                                  // disabledColor: Colors.orange,
                                  child: Text(
                                    "reteur".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 20, vertical: 12),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(80.0)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    Map<String, dynamic> data =
                                        orderProvider.getOrderData();
                                    data.addAll({'payment': _paymentMethod});
                                    orderProvider.setOrderData(data);
                                    // bool response =
                                    //     await orderProvider.makeOrder(context);
                                    // if (response) {
                                    //   Navigator.pop(context, true);
                                    // }
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    showSuccessDialog(context);
                                  },
                                  // color: Color(0xFFe31D1A),
                                  // disabledColor: Color(0xFFe31D1A),
                                  child: !_isLoading
                                      ? Text(
                                          "valider".toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        )
                                      : SizedBox(
                                          height: 15.0,
                                          width: 15.0,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white),
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 20, vertical: 12),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius:
                                  //         BorderRadius.circular(80.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showSuccessDialog(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              context.translate.finish_text,
              style: TextStyle(
                color: Color(0xFFe31D1A),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  context.translate.accept_order_message_text,
                ),
                Text(
                  context.translate.on_deliver_order_message_text,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    // color: Color(0xFFe31D1A),
                    // disabledColor: Color(0xFFe31D1A),
                    child: Text(
                      context.translate.continue_text.toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                    // padding: EdgeInsets.symmetric(
                    //     horizontal: 50, vertical: 12),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius:
                    //     BorderRadius.circular(
                    //         80.0)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

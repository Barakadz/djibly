import 'package:djibly/app/core/extensions/theme_eextensions.dart';

import 'orders_list_widget.dart';
import '../../presenters/order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersListPage extends StatefulWidget {
  static const String routeName = 'orders_list_page';

  @override
  _OrdersListPageState createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<OrderPresenter>(context, listen: false).setOrders(null);
        Navigator.of(context).pop();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            context.translate.my_orders,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<OrderPresenter>(context, listen: false)
                  .setOrders(null);
            },
          ),
          // bottom: ,
        ),
        body: OrdersListWidget(),
      ),
    );
  }
}

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/pages/make_order/delivery_widget.dart';
import 'package:djibly/pages/make_order/payment_widget.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MakeOrderPage extends StatefulWidget {
  static const String routeName = 'order_page';

  @override
  MakeOrderPageState createState() => MakeOrderPageState();
}

class MakeOrderPageState extends State<MakeOrderPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    Provider.of<CreateOrderPresenter>(MyApp.navigatorKey.currentContext,
            listen: false)
        .clearData();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Scaffold(
          appBar: CommonStyles.customAppBar(
              context, context.translate.confirm_text,
              showCart: false),
          body: DeliveryWidget(),
        ),
      ),
    );
  }
}

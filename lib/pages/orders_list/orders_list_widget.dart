import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/models/order.dart';
import 'package:djibly/pages/order_details/order_details_page.dart';
import 'package:djibly/pages/orders_list/order_widgets/order_widget.dart';
import 'package:djibly/presenters/order_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersListWidget extends StatefulWidget {
  const OrdersListWidget({Key key}) : super(key: key);

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget>
    with TickerProviderStateMixin {
  String selectedTab = Order.FETCH_PENDING;
  List<String> status = [
    Order.FETCH_PENDING,
    Order.FETCH_FINISHED,
    Order.FETCH_CANCELED,
  ];

  TabController tabController;

  @override
  void initState() {
    super.initState();
    Provider.of<OrderPresenter>(context, listen: false).setOrders(null);
    tabController = new TabController(vsync: this, length: 3, initialIndex: 0);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        Provider.of<OrderPresenter>(context, listen: false).setOrders(null);
        selectedTab = status[tabController.index];
      });
    }
  }

  Color _getIndicatorColor() {
    switch (selectedTab) {
      case Order.FETCH_PENDING:
        return Color(0xFFFF7A00);
      case Order.FETCH_FINISHED:
        return Color(0xFF007D32);
      default:
        return Color(0xFFE71722);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: TabBar(
                controller: tabController,
                indicatorColor: context.colorScheme.primary,
                labelColor: context.colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).pending_text,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).finished_text,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context).canceled_text,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: Consumer<OrderPresenter>(
                builder: (_, orderPresenter, ch) {
                  if (orderPresenter.getOrders() == null) {
                    orderPresenter.fetchOrders(selectedTab);
                    return Center(
                      child: SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int orderIndex) =>
                          InkWell(
                        onTap: () {
                          orderPresenter.setSelectedOrder(
                              orderPresenter.getOrders()[orderIndex]);
                          Navigator.of(context)
                              .pushNamed(OrderDetailsPage.routeName);
                        },
                        child: OrderWidget(
                            order: orderPresenter.getOrders()[orderIndex]),
                      ),
                      itemCount: orderPresenter.getOrders().length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 8,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

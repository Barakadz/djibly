import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/pages/pos/pos_page.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/models/cart_pos.dart';
import 'package:djibly/pages/cart/cart_footer.blade.dart';
import 'package:djibly/pages/cart/item_widget.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:djibly/pages/cart/delivery_price_widget.dart';

class CartPage extends StatefulWidget {
  static const String routeName = 'cart_page';
  static bool showReturn = true;

  const CartPage({
    Key key,
  }) : super(key: key);
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.shoppingCartAppBar(context),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Consumer<CartPresenter>(builder: (_, cartPresenter, ch) {
            if (cartPresenter.errorFetching)
              return Center(
                child: IconButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 50,
                    color: DjiblyColor,
                  ),
                  onPressed: () {
                    cartPresenter.errorFetching = false;
                    cartPresenter.fetchItems(true);
                  },
                ),
              );
            final List<CartPos> items = cartPresenter.getItems();
            if (cartPresenter.isFetching) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                  strokeWidth: 2.0,
                ),
              );
            } else {
              // if(items.length > 0)
              var length2 = cartPresenter.getSelectedItems().length;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16, right: 16, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${context.translate.total_selected_text} (${length2} ${length2 > 1 ? context.translate.items_text : context.translate.items_text})',
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          child: InkWell(
                              onTap: () {
                                if (cartPresenter.isAllItemsSelected()) {
                                  cartPresenter.deselectAllItems();
                                } else {
                                  cartPresenter.selectAllItems();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      cartPresenter.isAllItemsSelected() &&
                                              cartPresenter
                                                      .getSelectedItems()
                                                      .length >
                                                  0
                                          ? Icons.check_box
                                          : Icons
                                              .check_box_outline_blank_rounded,
                                      size: 17,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      context.translate.select_all,
                                      style: context.text.labelMedium,
                                    )
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    /*   print("POS NAME ${items[index].name}");
                                    print("POS id ${items[index].id}");
                                    Navigator.of(context).pushNamed(
                                        PosPage.routeName,
                                        arguments: {
                                          'name': items[index].name,
                                          'id': items[index].id
                                        }); */
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    title: Text(
                                      items[index].name,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: items[index].items.length,
                                  itemBuilder:
                                      (BuildContext itemCtxt, int itemIndex) {
                                    return ItemWidget(
                                      item: items[index].items[itemIndex],
                                      context: context,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: 12,
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: DeliveryPriceWidget(
                                        deliveryPrice:
                                            items[index].deliveryPrice,
                                        padding: 0.0,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                  CartFooter()
                ],
              );
              // else {
              //   return Container();
              // }
            }
          }),
        ),
      ),
    );
  }
}

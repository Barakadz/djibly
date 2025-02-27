import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/pages/make_order/delivery_address/selected_address_widget.dart';
import 'package:djibly/pages/make_order/delivery_type/ordered_products_widget.dart';
import 'package:djibly/pages/make_order/make_order_page.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/services/toast_service.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

class DeliveryWidget extends StatefulWidget {
  @override
  _DeliveryWidgetState createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<CreateOrderPresenter>(context, listen: false).getItems());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderPresenter>(builder: (_, orderProvider, ch) {
      return orderProvider.getPosList().length > 0
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      context.translate.total_price_text,
                                      style: context.text.labelLarge.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (orderProvider.totalProductPrice() +
                                            orderProvider.totalDeliveryPrice())
                                        .toDZD(),
                                    style: context.text.labelLarge.copyWith(),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              context.translate.personel_info_text
                                  .toTitleCase(),
                              style: context.text.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SelectedAddressWidget(
                              address: orderProvider.defaultAddress),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              context.translate.orders_list_text.toTitleCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                          Container(
                            child: Flexible(
                              child: OrderedProductsWidget(),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomElevatedButton(
                      onPressed: () async {
                        if (orderProvider.defaultAddress != null) {
                          Loader.show(context,
                              progressIndicator: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black),
                                strokeWidth: 2.0,
                              ));
                          Map<String, dynamic> data =
                              orderProvider.getOrderData();
                          bool response = await orderProvider.makeOrder(data);
                          if (response) {
                            ToastService.showSuccessToast(
                              context.translate.accept_order_message_text,
                            );

                            Navigator.of(context).pop();
                            showSuccessDialog(context);
                          }
                          Loader.hide();
                        } else {
                          ToastService.showErrorToast(
                              context.translate.select_address_error_text);
                        }
                      },
                      buttonColor: DjiblyColor,
                      isDisabled: false,
                      textColor: Colors.white,
                      child: Text(
                        context.translate.confirm_text.toTitleCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
                strokeWidth: 2.0,
              ),
            );
    });
  }

  showSuccessDialog(context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AllertDialogWidget();
      },
    );
  }
}

class AllertDialogWidget extends StatelessWidget {
  const AllertDialogWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
          child: Text(
            context.translate.completed_transaction_text,
            style: TextStyle(
              color: DjiblyColor,
            ),
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.translate.accept_order_message_text,
              style: context.text.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          /*  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.translate.on_deliver_order_message_text,
              style: TextStyle(fontSize: 13.0),
            ),
          ), */
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomElevatedButton(
                isDisabled: false,
                buttonColor: DjiblyColor,
                textColor: Colors.white,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                child: Text(
                  context.translate.continue_text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

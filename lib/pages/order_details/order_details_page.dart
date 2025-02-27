import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

import '../../app/core/extensions/theme_eextensions.dart';
import '../../presenters/order_presenter.dart';
import '../../services/toast_service.dart';
import '../../utilities/constants.dart';
import 'order_details_widget.dart';
import '../../utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailsPage extends StatefulWidget {
  static const String routeName = 'order_details_page';

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.orderDetailsAppBar(
          context, context.translate.order_details_text, cancel),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: OrderDetailsWidget(),
          ),
        ),
      ),
    );
  }

  String cancel(String choice) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Confirmation', textAlign: TextAlign.center),
            content: const Text('Voulez-vous vraiment annuler cette commande?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    // Close the dialog
                    Navigator.of(context).pop();
                    Loader.show(
                      context,
                      progressIndicator: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                        strokeWidth: 2.0,
                      ),
                    );

                    bool response = await Provider.of<OrderPresenter>(context,
                            listen: false)
                        .cancelSelectedOrder();
                    if (response) {
                      Navigator.of(context).pop();
                      Provider.of<OrderPresenter>(context, listen: false)
                          .fetchOrders("pending");
                      ToastService.showSuccessToast(
                          "Votre commande est annulée avec success");
                    }
                    Loader.hide();
                  },
                  child: const Text('Confirmer')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Fermer',
                    style: TextStyle(color: DjiblyColor),
                  ))
            ],
          );
        });
    return "value";
  }
}

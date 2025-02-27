import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/models/cart_pos.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../main.dart';

class SelectedDeliveryPriceWidget extends StatefulWidget {
  final CartPos pos;
  const SelectedDeliveryPriceWidget({Key key, @required this.pos})
      : super(key: key);

  @override
  _SelectedDeliveryPriceWidgetState createState() =>
      _SelectedDeliveryPriceWidgetState();
}

class _SelectedDeliveryPriceWidgetState
    extends State<SelectedDeliveryPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "+ ${AppLocalizations.of(MyApp.navigatorKey.currentContext).delivery_cost_text}",
                    textAlign: TextAlign.end,
                    style: TextStyle(color: LinksColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.pos.deliveryPrice.toDZD(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: LinksColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

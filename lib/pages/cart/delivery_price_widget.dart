import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/helpers/string_helper.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';

class DeliveryPriceWidget extends StatelessWidget {
  double deliveryPrice;
  double padding;
  DeliveryPriceWidget({Key key, this.deliveryPrice, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          deliveryPrice > 0
              ? "${AppLocalizations.of(MyApp.navigatorKey.currentContext).delivery_cost_text} "
              : "Livraison gratuite",
          style: context.text.labelLarge.copyWith(
            color: Colors.grey.shade500,
          ),
        ),
        Text(
          deliveryPrice > 0 ? " " + deliveryPrice.toDZD() : "",
          style: context.text.labelLarge.copyWith(),
        )
      ],
    );
  }
}

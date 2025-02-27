import 'dart:io';

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/pages/addresses/add_address/add_address_page.dart';
import 'package:djibly/pages/make_order/delivery_address/select_address_page.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedAddressWidget extends StatefulWidget {
  final UserAddress address;
  const SelectedAddressWidget({Key key, @required this.address})
      : super(key: key);

  @override
  _SelectedAddressWidgetState createState() => _SelectedAddressWidgetState();
}

class _SelectedAddressWidgetState extends State<SelectedAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CreateOrderPresenter>(builder: (_, orderProvider, ch) {
      return widget.address != null
          ? DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.translate.full_name_text,
                          style: context.text.labelLarge.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          widget.address.firstName +
                              ' ' +
                              widget.address.lastName,
                          style: context.text.labelLarge.copyWith(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            context.translate.phone_number_text,
                            style: context.text.labelLarge.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Text(
                          widget.address.phone,
                          style: context.text.labelLarge.copyWith(),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          context.translate.address_text,
                          style: context.text.labelLarge.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            widget.address.fullAddress,
                            style: context.text.labelLarge.copyWith(),
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.end,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SelectAddressWidget.routeName);
                          },
                          child: Text(
                            context.translate.edit_text,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AddAddressPage.routeName);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Ajouter une adresse",
                    style: TextStyle(fontSize: 16.0, color: LinksColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
    });
  }
}

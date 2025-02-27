import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/pages/addresses/address_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

import '../../services/toast_service.dart';

class UserAddresesWidget extends StatefulWidget {
  const UserAddresesWidget({Key key}) : super(key: key);

  @override
  _UserAddresesWidgetState createState() => _UserAddresesWidgetState();
}

class _UserAddresesWidgetState extends State<UserAddresesWidget> {
  deleteAddress(BuildContext context, id) async {
    Loader.show(
      context,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.black),
        strokeWidth: 2.0,
      ),
    );
    await Provider.of<UserAddress>(context, listen: false).deleteAddress(id);
    Loader.hide();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Consumer<UserAddress>(
        builder: (_, userAddresses, ch) => ListView.builder(
          itemCount: userAddresses.addresses.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              title: InkWell(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        content: Text(
                            context.translate.delete_address_confirmation_text),
                        actions: [
                          TextButton(
                            child: Text(context.translate.cancel_text),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(context.translate.confirm_text),
                            onPressed: () async {
                              await deleteAddress(
                                  context, userAddresses.addresses[index].id);
                              ToastService.showSuccessToast(context
                                  .translate.delete_address_successfully_text);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: AddressWidget(
                  address: userAddresses.addresses[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/pages/addresses/edit_address/edit_address_page.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatefulWidget {
  final UserAddress address;

  const AddressWidget({Key key, this.address}) : super(key: key);

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12,
          ),
          side: BorderSide(
              color: Colors.black12, width: widget.address.isDefault ? 0 : 0)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                /*  DecoratedBox(
                  decoration: BoxDecoration(
                      color: context.colorScheme.outline,
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.person_pin_circle_outlined,
                      size: 22.0,
                    ),
                  ),
                ), */
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Text(
                          widget.address.firstName +
                              ' ' +
                              widget.address.lastName +
                              ' , ' +
                              widget.address.phone,
                          style: context.text.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          widget.address.address +
                              " " +
                              widget.address.commune +
                              " " +
                              widget.address.fullAddress,
                          style: context.text.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            !widget.address.isDefault
                                ? InkWell(
                                    onTap: () async {
                                      Loader.show(context,
                                          progressIndicator:
                                              CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.black),
                                            strokeWidth: 2.0,
                                          ));
                                      bool response =
                                          await Provider.of<UserAddress>(
                                                  context,
                                                  listen: false)
                                              .setAddressAsDefault(
                                                  widget.address.id);

                                      Loader.hide();
                                    },
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          context.translate.set_default_address,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(EditAddressPage.routeName,
                        arguments: {'id': widget.address.id.toString()});
                  },
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8),
                      child: Icon(
                        FeatherIcons.edit,
                        size: 18,
                      )),
                ),
              ],
            ),
          ),
          widget.address.isDefault
              ? Positioned(
                  bottom: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        context.translate.default_text,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

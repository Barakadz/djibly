import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/commune.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/pages/addresses/add_address/add_address_form.dart';
import 'package:djibly/pages/addresses/edit_address/edit_address_form.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAddressPage extends StatefulWidget {
  static const String routeName = 'edit_address_page';

  const EditAddressPage({Key key}) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Commune>(
            create: (_) => Commune(),
          ),
          ChangeNotifierProvider<Wilaya>(
            create: (_) => Wilaya(),
          ),
        ],
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonStyles.customAppBar(
              context, context.translate.edit_text,
              showCart: false),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: EditAddressFrom(
                      addressId: args['id'],
                    )),
              ),
            ),
          ),
        ));
  }
}

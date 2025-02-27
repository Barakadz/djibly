import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/commune.dart';
import 'package:djibly/models/wilaya.dart';
import 'package:djibly/pages/addresses/add_address/add_address_form.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  static const String routeName = 'add_address_page';

  const AddAddressPage({Key key}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  @override
  Widget build(BuildContext context) {
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
              context, context.translate.add_address_text,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 32,
                    ),
                    child: AddAddressFrom()),
              ),
            ),
          ),
        ));
  }
}

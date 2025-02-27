import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/pages/addresses/add_address/add_address_page.dart';
import 'package:djibly/pages/addresses/user_addresses_widget.dart';
import 'package:djibly/ui/components/buttons/elevated_button.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserAddressesPage extends StatefulWidget {
  static const String routeName = 'user_addresses_page';

  const UserAddressesPage({Key key}) : super(key: key);

  @override
  _UserAddressesPageState createState() => _UserAddressesPageState();
}

class _UserAddressesPageState extends State<UserAddressesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonStyles.customAppBar(
          context, context.translate.my_addresses_text,
          showCart: false),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FutureBuilder(
              future: Provider.of<UserAddress>(context, listen: false)
                  .getAddresses(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserAddress>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: CommonStyles.errorConnectionWidget(context));
                    } else {
                      return UserAddresesWidget();
                    }
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).pushNamed(AddAddressPage.routeName);
        },
        child: Icon(
          Icons.add,
        ),
      ),
      /*  bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: CustomElevatedButton(
          buttonColor: DjiblyColor,
          isDisabled: false,
          onPressed: () async {
            Navigator.of(context).pushNamed(AddAddressPage.routeName);
          },
          // color: Color(0xFFe31D1A).withOpacity(0.8),
          child: Text(
            "Ajouter une adresse".toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        ), */
    );
  }
}

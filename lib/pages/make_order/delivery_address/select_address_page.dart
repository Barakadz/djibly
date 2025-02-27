import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/user_address.dart';
import 'package:djibly/pages/home/tabs/home_tab/products_view/home_products_view.dart';
import 'package:djibly/pages/make_order/delivery_address/user_address_list_controller.dart';
import 'package:djibly/presenters/create_order_presenter.dart';
import 'package:djibly/utilities/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../addresses/add_address/add_address_page.dart';

class SelectAddressWidget extends StatelessWidget {
  static const String routeName = 'select_address_page';

  const SelectAddressWidget();

  @override
  Widget build(BuildContext context) {
    Get.put(UserAddressesListController());
    final controller = Get.find<UserAddressesListController>();
    controller.initPage();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate.my_addresses_text,
        ),
      ),
      body: Obx(
        () => controller.isLoading.isTrue
            ? Center(
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.black,
                    ),
                    strokeWidth: 2.0,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.builder(
                  itemCount: controller.list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: InkWell(
                        onTap: () async {
                          await Provider.of<CreateOrderPresenter>(context,
                                  listen: false)
                              .selectDefaultAddress(controller.list[index]);
                          Navigator.of(context).pop();
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 16,
                                    ),
                                    child: Icon(
                                      Icons.person_pin_circle_outlined,
                                      size: 30.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            child: Text(
                                              controller.list[index].firstName +
                                                  ' ' +
                                                  controller
                                                      .list[index].lastName +
                                                  ', ' +
                                                  controller.list[index].phone,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            child: Text(
                                              controller.list[index].address,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            child: Text(
                                              controller.list[index].commune,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            child: Text(
                                              controller
                                                  .list[index].fullAddress,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(AddAddressPage.routeName);
          controller.initPage();
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

/* class SelectAddressWidget extends StatefulWidget {
  static const String routeName = 'select_address_page';

  const SelectAddressWidget({Key key}) : super(key: key);

  @override
  _SelectAddressWidgetState createState() => _SelectAddressWidgetState();
}

class _SelectAddressWidgetState extends State<SelectAddressWidget> {
  @override
  Widget build(BuildContext context) {
    /*  Get.put(UserAddressesListController());
    final controller = Get.find<UserAddressesListController>();
    */ // if (controller.isLoading.isTrue) return Obx(() => Scaffold());
    return Scaffold(
      appBar:
          CommonStyles.customAppBar(context, 'Mes Adresses', showCart: false),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: FutureBuilder(
              future: Provider.of<CreateOrderPresenter>(
                context,
                listen: false,
              ).getAddresses(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserAddress>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Colors.black,
                          ),
                          strokeWidth: 2.0,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(
                          child: CommonStyles.errorConnectionWidget(context));
                    } else {
                      return Consumer<CreateOrderPresenter>(
                        builder: (_, createOrder, ch) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            itemCount: createOrder.addresses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: InkWell(
                                  onTap: () async {
                                    await Provider.of<CreateOrderPresenter>(
                                            context,
                                            listen: false)
                                        .selectDefaultAddress(
                                            createOrder.addresses[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Card(
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons
                                                    .person_pin_circle_outlined,
                                                size: 30.0,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        createOrder
                                                                .addresses[
                                                                    index]
                                                                .firstName +
                                                            ' ' +
                                                            createOrder
                                                                .addresses[
                                                                    index]
                                                                .lastName +
                                                            ', ' +
                                                            createOrder
                                                                .addresses[
                                                                    index]
                                                                .phone,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        createOrder
                                                            .addresses[index]
                                                            .address,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        createOrder
                                                            .addresses[index]
                                                            .commune,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8.0,
                                                          vertical: 2.0),
                                                      child: Text(
                                                        createOrder
                                                            .addresses[index]
                                                            .fullAddress,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 15.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(AddAddressPage.routeName);
          if (result != null) setState(() {});
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
 */
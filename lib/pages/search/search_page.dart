import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/main.dart';
import 'package:djibly/pages/cart/badge.dart';
import 'package:djibly/pages/cart/cart_page.dart';
import 'package:djibly/pages/products/products_list_widget.dart';
import 'package:djibly/presenters/cart_presenter.dart';
import 'package:djibly/presenters/search_presenter.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../presenters/search_controller.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = 'search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _scrollController = ScrollController();

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Get.find<SearchController>().loadMore();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchController());
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.only(right: 16),
          child: SizedBox(
            width: double.maxFinite,
            height: 40.0,
            child: Obx(
              () => TextFormField(
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller.searchController.value,
                onFieldSubmitted: (String value) {
                  print("🟢🟢🟢🟢  onFieldSubmitted");
                  controller.searchQuery.value = value;
                  controller.isFirstSearch.value = true;
                  search();
                },
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  contentPadding: new EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  hintText: context.translate.search_product,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  prefixIcon: Icon(
                    FeatherIcons.search,
                    size: 16,
                  ),
                  suffixIcon: controller.showCleanText.value
                      ? GestureDetector(
                          onTap: () {
                            controller.searchController.value.clear();
                            controller.products.value = [];
                            controller.emptySearch.value = false;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                FeatherIcons.x,
                                size: 16,
                              ),
                            ),
                          ),
                        )
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                style: TextStyle(fontSize: 13.0, height: 2.0),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 30.0,
          ),
          onPressed: () {
            closePage();
          },
        ),
        actions: [
          /*       Consumer<CartPresenter>(
            builder: (_, cartPresenter, ch) => CartBadge(
              value: cartPresenter.getNumberOfItems() > 0
                  ? cartPresenter.getNumberOfItems().toString()
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ),
        */
        ],
      ),
      body: SafeArea(
        child: GestureDetector(onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            search();
          }
        }, child: Obx(() {
          return controller.isSearching.value
              ? Center(
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : WillPopScope(
                  onWillPop: () {
                    closePage();
                    return;
                  },
                  child: controller.emptySearch.value &&
                          controller.isFirstSearch.value
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: controller.searchQuery.value.isNotEmpty
                                      ? Icon(
                                          Icons.search_off,
                                          size: 40,
                                        )
                                      : Icon(
                                          Icons.hourglass_empty,
                                          size: 40,
                                        ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                controller.searchQuery.value.isNotEmpty
                                    ? context.translate.no_results_found(
                                        "'${controller.searchQuery.value}'")
                                    : context.translate.start_searching,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : Obx(
                          () => SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Column(
                                children: [
                                  ProductsListWidget(
                                    products: controller.products.value,
                                  ),
                                  if (controller.isLoadingMore.value)
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.black),
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                );
        })),
      ),
    );
  }

  void closePage() {
    Provider.of<SearchPresenter>(context, listen: false).initData();
    Navigator.of(context).pop();
  }

  void search() {
    print("🟢🟢🟢🟢  search");
    final controller = Get.find<SearchController>();
    if (controller.searchController.value.text.length >= 3)
      controller.searchPosProduct();
  }
}

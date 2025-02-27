import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/models/pos.dart';
import 'package:djibly/pages/pos/pos_widget.dart';
import 'package:djibly/pages/products/products_list_widget.dart';
import 'package:djibly/presenters/pos_presenter.dart';
import 'package:djibly/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../presenters/pos_controller.dart';

// ignore: must_be_immutable
class PosPage extends StatefulWidget {
  static const String routeName = 'pos_page';

  @override
  _PosPageState createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  //String name;
  Map<String, dynamic> _pos;
  TabController tabController;
  ScrollController _scrollController = ScrollController();

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<PosPresenter>(context, listen: false).loadMore();
    }
  }

  @override
  void initState() {
    super.initState();
    Get.put(PosController());
    tabController = new TabController(vsync: this, length: 4, initialIndex: 0);
    tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_scrollListener);
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging) {
      Get.find<PosController>().setSelectedTab(tabController.index);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PosController>();
    _pos = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    return WillPopScope(
      onWillPop: () {
        closePage();
        return;
      },
      child: Scaffold(
        key: _drawerKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            _pos["name"],
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 22,
            ),
            onPressed: () {
              closePage();
            },
          ),
        ),
        body: Obx(() {
          Pos pos;
          if (controller.errorFetching.value) {
            return Center(
              child: Text(context.translate.something_went_wrong_body),
            );
          } else {
            pos = controller.getSelectedPos(_pos['id']);
            if (controller.isFetching.value &&
                controller.isTabChanging.isFalse) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black),
                  strokeWidth: 2.0,
                ),
              );
            } else {
              return Column(
                children: [
                  Divider(height: .5),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        PosWidget(pos: pos),
                        Divider(),
                        TabBar(
                          controller: tabController,
                          indicatorColor: DjiblyColor,
                          labelColor: Colors.black,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Iconsax.shop,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.phone_android_outlined,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.tablet,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Iconsax.headphone,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.isTabChanging.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.black),
                              strokeWidth: 2.0,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: [
                                ProductsListWidget(
                                  products: controller.products.value,
                                  controller: controller.scrollController,
                                ),
                                if (controller.isLoadingMore.value)
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
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
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                Colors.black,
                                              ),
                                              strokeWidth: 2.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  )
                ],
              );
            }
          }
        }),
      ),
    );
  }

  void closePage() {
    Get.delete<PosController>();
    Navigator.of(context).pop();
  }
}

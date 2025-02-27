import 'package:djibly/app/core/extensions/theme_eextensions.dart';
import 'package:djibly/pages/wishlist/wishlist_widget.dart';
import 'package:djibly/presenters/wishlist_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  static String routeName = "wishlist_page";

  const WishlistPage({Key key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  ScrollController _scrollController = ScrollController();

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<WishlistPresenter>(context, listen: false).loadMore();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        closePage();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            context.translate.favorite_text,
            style: TextStyle(
              color: Colors.black,
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
        ),
        body: SafeArea(
          child: GestureDetector(
            child: Consumer<WishlistPresenter>(
                builder: (context, wishlistPresenter, child) {
              if (wishlistPresenter.errorFetching) {
                return Center(
                  child: Text(context.translate.something_went_wrong_body),
                );
              } else {
                wishlistPresenter.getWishlist();
                if (wishlistPresenter.isFetching) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      strokeWidth: 2.0,
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: WishlistWidget(
                              products: wishlistPresenter.products),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 40.0,
                            width: 40.0,
                            child: wishlistPresenter.isLoadingMore
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.black),
                                    strokeWidth: 2.0,
                                  )
                                : SizedBox(
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
          ),
        ),
      ),
    );
  }

  void closePage() {
    Provider.of<WishlistPresenter>(context, listen: false).initData();
    Navigator.of(context).pop();
  }
}

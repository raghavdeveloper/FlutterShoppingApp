//@dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/providers/store_provider.dart';
import 'package:flutter_shopping_app/widgets/categories_widget.dart';
import 'package:flutter_shopping_app/widgets/image_slider.dart';
import 'package:flutter_shopping_app/widgets/my_appbar.dart';
import 'package:flutter_shopping_app/widgets/shop_appbar.dart';
import 'package:flutter_shopping_app/widgets/shop_banner.dart';
import 'package:provider/provider.dart';

class ShopHomeScreen extends StatelessWidget {
  static const String id = 'shop-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [ShopAppBar()];
        },
        body: Center(
          child: Column(
            children: [
              ShopBanner(),
              Expanded(child: ShopCategories()),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provider/shop_cart_provider.dart';
import 'package:provider/provider.dart';
import 'shop_cart_widget/shop_cart_item_widget.dart';
import 'shop_cart_widget/shop_cart_bottom_widget.dart';

class ShopCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      //通过consumer从provider取值
      body: Consumer<ShopCartProvider>(builder:
          (BuildContext context, ShopCartProvider value, Widget child) {
        value.getShopCartGoods();
        return Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: value.cartGoodsList.length,
                itemBuilder: (context, index) {
                  return ShopCartItemWidget(value.cartGoodsList[index]);
                }),
            Positioned(
              left: 0,
              bottom: 0,
              child: ShopCartBottomWidget(
                  value.totalCount, value.totalPrice, value.allSelected),
            ),
          ],
        );
      }),
    );
  }
}

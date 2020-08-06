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

      body: Stack(
        children: <Widget>[
          Consumer<ShopCartProvider>(
            builder: (context, value, child) {
              value.getShopCartGoods();
              if (value.cartGoodsList.length == 0) {
                return Container(
                  child: Text('购物车空空如也'),
                  width: ScreenUtil().setWidth(750),
                  height: ScreenUtil().setHeight(1344),
                );
              } else {
                return ListView.builder(
                    itemCount: value.cartGoodsList.length,
                    itemBuilder: (context, index) {
                      return ShopCartItemWidget(value.cartGoodsList[index]);
                    });
              }
            },
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: ShopCartBottomWidget(),
          ),
        ],
      ),
      // 通过consumer从provider取值
      // body: Consumer<ShopCartProvider>(builder:
      //     (BuildContext context, ShopCartProvider value, Widget child) {
      //   value.getShopCartGoods();
      //   if (value.cartGoodsList.length == 0) {
      //     return Text('购物车空空如也');
      //   } else {
      //     return Stack(
      //       children: <Widget>[
      //         ListView.builder(
      //             itemCount: value.cartGoodsList.length,
      //             itemBuilder: (context, index) {
      //               return ShopCartItemWidget(value.cartGoodsList[index]);
      //             }),
      //         Positioned(
      //           left: 0,
      //           bottom: 0,
      //           child: ShopCartBottomWidget(),
      //         ),
      //       ],
      //     );
      //   }
      // }),
    );
  }
}

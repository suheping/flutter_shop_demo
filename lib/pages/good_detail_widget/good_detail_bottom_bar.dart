import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provider/good_detail_provider.dart';
import '../../provider/shop_cart_provider.dart';
import 'package:provider/provider.dart';

class GoodDetailBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodinfo = context.watch<GoodDetailPorvider>().goodDetail.data.goodInfo;
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: ScreenUtil().setWidth(110),
            height: ScreenUtil().setHeight(110),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.red,
                // size: ScreenUtil().setHeight(40),
                size: 40,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<ShopCartProvider>().addToCart(goodinfo.goodsId,
                  goodinfo.goodsName, goodinfo.presentPrice, goodinfo.image1);
            },
            child: Container(
              height: ScreenUtil().setHeight(110),
              width: ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<ShopCartProvider>().clearCart();
            },
            child: Container(
              height: ScreenUtil().setHeight(110),
              width: ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                '立即购买',
                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/shop_cart_goods_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shop/provider/shop_cart_provider.dart';

class ShopCartGoodCountWidget extends StatelessWidget {
  ShopCartGoodModel item;
  ShopCartGoodCountWidget(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(300),
        margin: EdgeInsets.only(top: 10),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.bottomLeft,
        child: Container(
          width: ScreenUtil().setWidth(163),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12)),
          child: Row(
            children: <Widget>[
              _reduceButton(context),
              _countText(),
              _addButton(context)
            ],
          ),
        ));
  }

  Widget _reduceButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ShopCartProvider>().setItemCount(item, 'reduce');
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(45),
        decoration: BoxDecoration(
            color: item.count > 1 ? Colors.white : Colors.black12,
            border: Border(right: BorderSide(color: Colors.black12, width: 1))),
        child: Text('-'),
      ),
    );
  }

  Widget _countText() {
    return Container(
      width: ScreenUtil().setWidth(70),
      // height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      child: Text('${item.count}'),
    );
  }

  Widget _addButton(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ShopCartProvider>().setItemCount(item, 'add');
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(45),
        // height: ScreenUtil().setHeight(45),
        decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.black12, width: 1))),
        child: Text('+'),
      ),
    );
  }
}

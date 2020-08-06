import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/shop_cart_goods_model.dart';
import 'shop_cart_good_count_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/shop_cart_provider.dart';

class ShopCartItemWidget extends StatelessWidget {
  ShopCartGoodModel item;
  ShopCartItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black26, width: 1))),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _itemCheckBox(context, item),
          _itemImage(),
          Container(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[_itemName(), ShopCartGoodCountWidget()],
            ),
          ),
          Column(
            children: <Widget>[_itemPrice(), _itemDelete(context, item)],
          )
        ],
      ),
    );
  }

  // checkbox
  Widget _itemCheckBox(BuildContext context, ShopCartGoodModel item) {
    return Container(
      width: ScreenUtil().setWidth(80),
      alignment: Alignment.center,
      child: Checkbox(
        onChanged: (value) {
          item.selected = value;
          context.read<ShopCartProvider>().setSelected(item);
        },
        value: item.selected,
        activeColor: Colors.pink,
      ),
    );
  }

  // 图片
  Widget _itemImage() {
    return Container(
      width: ScreenUtil().setWidth(200),
      // height: ,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black26, width: 1)),
      child: Image.network(item.image),
    );
  }

  // 名称
  Widget _itemName() {
    return Container(
      width: ScreenUtil().setWidth(300),
      alignment: Alignment.topLeft,
      child: Text(
        item.goodName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  // 价格
  Widget _itemPrice() {
    return Container(
        width: ScreenUtil().setWidth(100),
        alignment: Alignment.centerRight,
        child: Text(
          '￥${item.price}',
          style: TextStyle(fontSize: ScreenUtil().setSp(22)),
        ));
  }

  // 删除按钮
  Widget _itemDelete(BuildContext context, ShopCartGoodModel item) {
    return InkWell(
      onTap: () {
        context.read<ShopCartProvider>().removeShopCartGood(item.goodId);
      },
      child: Container(
        width: ScreenUtil().setWidth(100),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_forever,
          size: 30,
          color: Colors.black38,
        ),
      ),
    );
  }
}

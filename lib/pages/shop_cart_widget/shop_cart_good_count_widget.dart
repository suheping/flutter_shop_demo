import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopCartGoodCountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(300),
        margin: EdgeInsets.only(top: 5),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.bottomLeft,
        child: Container(
          width: ScreenUtil().setWidth(163),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black12)),
          child: Row(
            children: <Widget>[_reduceButton(), _countText(), _addButton()],
          ),
        ));
  }

  Widget _reduceButton() {
    return InkWell(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(45),
        // height: ScreenUtil().setHeight(45),
        decoration: BoxDecoration(
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
      child: Text('99'),
    );
  }

  Widget _addButton() {
    return InkWell(
      onTap: () {},
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

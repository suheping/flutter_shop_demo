import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopCartBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _checkBoxWidget(),
          _sumWidget(),
          _settlementButton()
        ],
      ),
    );
  }

  // checkbox
  Widget _checkBoxWidget() {
    return Container(
      padding: EdgeInsets.all(5),

      width: ScreenUtil().setWidth(200),
      // alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Checkbox(
            onChanged: (value) {},
            value: true,
            activeColor: Colors.pink,
          ),
          Text('全选')
        ],
      ),
    );
  }

  // 合计
  Widget _sumWidget() {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(350),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(160),
                alignment: Alignment.centerRight,
                child: Text(
                  '合计：',
                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(166),
                child: Text(
                  '￥99999.00',
                  style: TextStyle(
                      color: Colors.pink, fontSize: ScreenUtil().setSp(24)),
                ),
              )
            ],
          ),
          Container(
              width: ScreenUtil().setWidth(320),
              alignment: Alignment.centerRight,
              child: Text('满68元免配送费，预约免配送费')),
        ],
      ),
    );
  }

  Widget _settlementButton() {
    return Container(
      padding: EdgeInsets.all(5),
      // width: ScreenUtil().setWidth(200),
      // alignment: Alignment.centerRight,
      child: RaisedButton(
        onPressed: () {},
        color: Colors.pink,
        child: Text(
          '结算（2）',
          style:
              TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }
}

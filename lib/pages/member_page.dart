import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人中心'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _memberTopWidget(),
            _billAreaWidget(),
            _memberBottomWidget()
          ],
        ),
      ),
    );
  }

  // 顶部头像区域
  Widget _memberTopWidget() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(500),
      color: Colors.pink[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(300),
            padding: EdgeInsets.all(5),
            child: ClipOval(
              child: Image.network(
                  'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596796578713&di=d869bb6955cb0ae32409b062db5a0e44&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201810%2F18%2F20181018164757_okcuo.thumb.700_0.jpeg'),
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: 10),
            child: Text(
              '一只猪',
              style: TextStyle(fontSize: ScreenUtil().setSp(40)),
            ),
          )
        ],
      ),
    );
  }

  // 订单区域
  Widget _billAreaWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: <Widget>[
          // 我的订单
          Container(
            padding: EdgeInsets.all(5),
            width: ScreenUtil().setWidth(750),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1))),
            child: ListTile(
              leading: Icon(Icons.format_list_numbered),
              title: Text('我的订单'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),

          // 订单分类
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                _billTypeItemWidget(Icon(Icons.attach_money), '待付款'),
                _billTypeItemWidget(Icon(Icons.access_time), '待发货'),
                _billTypeItemWidget(Icon(Icons.directions_car), '待收货'),
                _billTypeItemWidget(Icon(Icons.content_paste), '待评价'),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 单个订单分类
  Widget _billTypeItemWidget(Widget icon, String typeName) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(187),
        child: Column(
          children: <Widget>[
            Container(
              child: icon,
            ),
            Container(
              child: Text(typeName),
            )
          ],
        ),
      ),
    );
  }

  // 个人中心下部
  Widget _memberBottomWidget() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      width: ScreenUtil().setWidth(750),
      child: Column(
        children: <Widget>[
          _listTileWidget(Icon(Icons.favorite), '我的收藏'),
          _listTileWidget(Icon(Icons.add_location), '收货地址'),
          _listTileWidget(Icon(Icons.account_balance_wallet), '我的卡包'),
          _listTileWidget(Icon(Icons.local_convenience_store), '我的客服'),
          _listTileWidget(Icon(Icons.info), '关于我们'),
        ],
      ),
    );
  }

  // 单个listtile
  Widget _listTileWidget(Widget leading, String title) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: ListTile(
        leading: leading,
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }
}

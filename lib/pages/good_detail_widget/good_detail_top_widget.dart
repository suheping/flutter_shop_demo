import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provider/good_detail_provider.dart';
import 'package:provider/provider.dart';

class GoodDetailTopWidge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodInfo = context.watch<GoodDetailPorvider>().goodDetail.data.goodInfo;
    // var goodDetail = Provider.of<GoodDetailPorvider>(context).goodDetail;
    if (goodInfo != null) {
      return Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                _goodImageWidget(goodInfo.image1),
                _goodNameWidget(goodInfo.goodsName),
                _goodDeliveryWidget(),
                _goodNumWidget(goodInfo.goodsSerialNumber),
                _goodPriceWidget(goodInfo.presentPrice, goodInfo.oriPrice),
              ],
            ),
          ),
          _goodExplainWidget()
        ],
      );
    } else {
      return Text('加载中');
    }
  }

  // 商品图片
  Widget _goodImageWidget(String imageUrl) {
    return Image.network(
      imageUrl,
      width: ScreenUtil().setWidth(740),
    );
  }

  // 商品名称
  Widget _goodNameWidget(String goodName) {
    return Container(
      width: ScreenUtil().setWidth(740),
      child: Text(
        goodName,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }

  Widget _goodDeliveryWidget() {
    return Container(
      width: ScreenUtil().setWidth(740),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green[100],
            border: Border.all(color: Colors.green, width: 1)),
        child: Text('支持配送到家'),
      ),
    );
  }

  // 商品编号
  Widget _goodNumWidget(String goodNum) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      width: ScreenUtil().setWidth(740),
      child: Text(
        '编号：$goodNum',
        style: TextStyle(color: Colors.black26),
      ),
    );
  }

  // 商品价格
  Widget _goodPriceWidget(double presentPrice, double oriPrice) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            '￥$presentPrice          ',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text('市场价：   '),
          Text(
            '￥$oriPrice',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  // 商品说明
  Widget _goodExplainWidget() {
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(10),
      child: Text(
        '说明： >急速送达 >正品保证',
        style: TextStyle(color: Colors.redAccent),
      ),
    );
  }
}
